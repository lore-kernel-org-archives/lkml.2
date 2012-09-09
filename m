Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2IIXbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:31:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51212 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab2IIXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:14 -0400
Message-Id: <20120909224201.844205422@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [ 82/95] random: Add comment to random_initialize()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9793b40..1a2dfa8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1087,6 +1087,16 @@ static void init_std_data(struct entropy_store *r)
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


