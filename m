Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2HMWI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:08:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56083 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HMWFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Theodore Tso <tytso@mit.edu>, Tony Luck <tony.luck@intel.com>
Subject: [ 32/44] random: Add comment to random_initialize()
Date: Mon, 13 Aug 2012 15:02:39 -0700
Message-Id: <20120813220144.987022389@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1087,6 +1087,16 @@ static void init_std_data(struct entropy
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


