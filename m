Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab0HEWXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:23:46 -0400
Received: from kroah.org ([198.145.64.141]:37547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421Ab0HEWXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/67] vt: clean up the code - use kernel library
Date: Thu,  5 Aug 2010 15:22:30 -0700
Message-Id: <1281047014-23429-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..1ff87fa 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/ctype.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -1789,8 +1790,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state = ESnormal;
 		return;
 	case ESpalette:
-		if ( (c>='0'&&c<='9') || (c>='A'&&c<='F') || (c>='a'&&c<='f') ) {
-			vc->vc_par[vc->vc_npar++] = (c > '9' ? (c & 0xDF) - 'A' + 10 : c - '0');
+		if (isxdigit(c)) {
+			vc->vc_par[vc->vc_npar++] = hex_to_bin(c);
 			if (vc->vc_npar == 7) {
 				int i = vc->vc_par[0] * 3, j = 1;
 				vc->vc_palette[i] = 16 * vc->vc_par[j++];
-- 
1.7.2

