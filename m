Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2HOT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:56:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:37423 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2HOTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tony Luck <tony.luck@intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 162/165] random: Add comment to random_initialize()
Date: Wed, 15 Aug 2012 15:48:26 -0400
Message-ID: <1345060109-9187-163-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
---
 drivers/char/random.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1644b8e..7e19406 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1088,6 +1088,16 @@ static void init_std_data(struct entropy_store *r)
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
1.7.12.rc2

