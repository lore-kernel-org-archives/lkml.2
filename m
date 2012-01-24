Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2AXCov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2AXCop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.612030877@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [053/129] UBI: fix debugging messages
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1446
Lines: 36

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 72f0d453d81d35087b1d3ad7c8285628c2be6e1d upstream.

Patch ab50ff684707031ed4bad2fdd313208ae392e5bb broke UBI debugging messages:
before that commit when UBI debugging was enabled, users saw few useful
debugging messages after attaching an MTD device. However, that patch turned
'dbg_msg()' into 'pr_debug()', so to enable the debugging messages users have
to enable them first via /sys/kernel/debug/dynamic_debug/control, which is
very impractical.

This commit makes 'dbg_msg()' to use 'printk()' instead of 'pr_debug()', just
as it was before the breakage.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/debug.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/ubi/debug.h
+++ b/drivers/mtd/ubi/debug.h
@@ -43,7 +43,10 @@
 	pr_debug("UBI DBG " type ": " fmt "\n", ##__VA_ARGS__)
 
 /* Just a debugging messages not related to any specific UBI subsystem */
-#define dbg_msg(fmt, ...) ubi_dbg_msg("msg", fmt, ##__VA_ARGS__)
+#define dbg_msg(fmt, ...)                                    \
+	printk(KERN_DEBUG "UBI DBG (pid %d): %s: " fmt "\n", \
+	       current->pid, __func__, ##__VA_ARGS__)
+
 /* General debugging messages */
 #define dbg_gen(fmt, ...) ubi_dbg_msg("gen", fmt, ##__VA_ARGS__)
 /* Messages from the eraseblock association sub-system */


