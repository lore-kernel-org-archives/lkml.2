Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2AWXsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:48:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab2AWXsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:48:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:26 2012
Message-Id: <20120123234025.996367179@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [36/90] UBIFS: fix debugging messages
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit d34315da9146253351146140ea4b277193ee5e5f upstream.

Patch 56e46742e846e4de167dde0e1e1071ace1c882a5 broke UBIFS debugging messages:
before that commit when UBIFS debugging was enabled, users saw few useful
debugging messages after mount. However, that patch turned 'dbg_msg()' into
'pr_debug()', so to enable the debugging messages users have to enable them
first via /sys/kernel/debug/dynamic_debug/control, which is very impractical.

This commit makes 'dbg_msg()' to use 'printk()' instead of 'pr_debug()', just
as it was before the breakage.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/debug.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -134,7 +134,10 @@ const char *dbg_key_str1(const struct ub
 } while (0)
 
 /* Just a debugging messages not related to any specific UBIFS subsystem */
-#define dbg_msg(fmt, ...)   ubifs_dbg_msg("msg", fmt, ##__VA_ARGS__)
+#define dbg_msg(fmt, ...)                                                     \
+	printk(KERN_DEBUG "UBIFS DBG (pid %d): %s: " fmt "\n", current->pid,  \
+	       __func__, ##__VA_ARGS__)
+
 /* General messages */
 #define dbg_gen(fmt, ...)   ubifs_dbg_msg("gen", fmt, ##__VA_ARGS__)
 /* Additional journal messages */


