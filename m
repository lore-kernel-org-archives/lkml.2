Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab2JAXRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:17:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35450 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab2JAXBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:53 -0400
Message-Id: <20121001225205.117322009@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Theodore Tso <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 177/180] random: Add comment to random_initialize()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit cbc96b7594b5691d61eba2db8b2ea723645be9ca upstream.

Many platforms have per-machine instance data (serial numbers,
asset tags, etc.) squirreled away in areas that are accessed
during early system bringup. Mixing this data into the random
pools has a very high value in providing better random data,
so we should allow (and even encourage) architecture code to
call add_device_randomness() from the setup_arch() paths.

However, this limits our options for internal structure of
the random driver since random_initialize() is not called
until long after setup_arch().

Add a big fat comment to rand_initialize() spelling out
this requirement.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index cbb63b0..446b20a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1077,6 +1077,16 @@ static void init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
 }
 
+/*
+ * Note that setup_arch() may call add_device_randomness()
+ * long before we get here. This allows seeding of the pools
+ * with some platform dependent data very early in the boot
+ * process. But it limits our options here. We must use
+ * statically allocated structures that already have all
+ * initializations complete at compile time. We should also
+ * take care not to overwrite the precious per platform data
+ * we were given.
+ */
 static int rand_initialize(void)
 {
 	init_std_data(&input_pool);
-- 
1.7.2.1.45.g54fbc



