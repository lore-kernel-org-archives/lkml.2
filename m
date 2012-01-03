Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2ACWfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2ACWf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.441557351@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ilya Yanok <yanok@emcraft.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [25/67] mfd: Fix twl-core oops while calling twl_i2c_* for unbound driver
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Yanok <yanok@emcraft.com>

commit 8653be1afd60d6e8c36139b487e375b70357d9ef upstream.

Check inuse variable before trying to access twl_map to prevent
dereferencing of uninitialized variable.

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/twl-core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -362,13 +362,13 @@ int twl_i2c_write(u8 mod_no, u8 *value,
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
-
 	if (unlikely(!inuse)) {
-		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
+		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
+	sid = twl_map[mod_no].sid;
+	twl = &twl_modules[sid];
+
 	mutex_lock(&twl->xfer_lock);
 	/*
 	 * [MSG1]: fill the register address data
@@ -419,13 +419,13 @@ int twl_i2c_read(u8 mod_no, u8 *value, u
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
-
 	if (unlikely(!inuse)) {
-		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
+		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
+	sid = twl_map[mod_no].sid;
+	twl = &twl_modules[sid];
+
 	mutex_lock(&twl->xfer_lock);
 	/* [MSG1] fill the register address data */
 	msg = &twl->xfer_msg[0];


