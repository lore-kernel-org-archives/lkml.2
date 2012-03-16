Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946478Ab2CPXlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:41:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946453Ab2CPXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:29 -0400
Message-Id: <20120316233813.916893057@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>, Chul Kim <chul.kim@idt.com>
Subject: [ 37/41] rapidio/tsi721: fix bug in register offset definitions
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 9bbad7da76b3dd578fb55c862624366a8c9ccd22 upstream.

Fix indexed register offset definitions that use decimal (wrong) instead
of hexadecimal (correct) notation for indexing multipliers.

Incorrect definitions do not affect Tsi721 driver in its current default
configuration because it uses only IDB queue 0.  Loss of inbound
doorbell functionality should be observed if queue other than 0 is used.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Chul Kim <chul.kim@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/rapidio/devices/tsi721.h
+++ b/drivers/rapidio/devices/tsi721.h
@@ -118,34 +118,34 @@
 
 #define TSI721_IDB_ENTRY_SIZE	64
 
-#define TSI721_IDQ_CTL(x)	(0x20000 + (x) * 1000)
+#define TSI721_IDQ_CTL(x)	(0x20000 + (x) * 0x1000)
 #define TSI721_IDQ_SUSPEND	0x00000002
 #define TSI721_IDQ_INIT		0x00000001
 
-#define TSI721_IDQ_STS(x)	(0x20004 + (x) * 1000)
+#define TSI721_IDQ_STS(x)	(0x20004 + (x) * 0x1000)
 #define TSI721_IDQ_RUN		0x00200000
 
-#define TSI721_IDQ_MASK(x)	(0x20008 + (x) * 1000)
+#define TSI721_IDQ_MASK(x)	(0x20008 + (x) * 0x1000)
 #define TSI721_IDQ_MASK_MASK	0xffff0000
 #define TSI721_IDQ_MASK_PATT	0x0000ffff
 
-#define TSI721_IDQ_RP(x)	(0x2000c + (x) * 1000)
+#define TSI721_IDQ_RP(x)	(0x2000c + (x) * 0x1000)
 #define TSI721_IDQ_RP_PTR	0x0007ffff
 
-#define TSI721_IDQ_WP(x)	(0x20010 + (x) * 1000)
+#define TSI721_IDQ_WP(x)	(0x20010 + (x) * 0x1000)
 #define TSI721_IDQ_WP_PTR	0x0007ffff
 
-#define TSI721_IDQ_BASEL(x)	(0x20014 + (x) * 1000)
+#define TSI721_IDQ_BASEL(x)	(0x20014 + (x) * 0x1000)
 #define TSI721_IDQ_BASEL_ADDR	0xffffffc0
-#define TSI721_IDQ_BASEU(x)	(0x20018 + (x) * 1000)
-#define TSI721_IDQ_SIZE(x)	(0x2001c + (x) * 1000)
+#define TSI721_IDQ_BASEU(x)	(0x20018 + (x) * 0x1000)
+#define TSI721_IDQ_SIZE(x)	(0x2001c + (x) * 0x1000)
 #define TSI721_IDQ_SIZE_VAL(size)	(__fls(size) - 4)
 #define TSI721_IDQ_SIZE_MIN	512
 #define TSI721_IDQ_SIZE_MAX	(512 * 1024)
 
-#define TSI721_SR_CHINT(x)	(0x20040 + (x) * 1000)
-#define TSI721_SR_CHINTE(x)	(0x20044 + (x) * 1000)
-#define TSI721_SR_CHINTSET(x)	(0x20048 + (x) * 1000)
+#define TSI721_SR_CHINT(x)	(0x20040 + (x) * 0x1000)
+#define TSI721_SR_CHINTE(x)	(0x20044 + (x) * 0x1000)
+#define TSI721_SR_CHINTSET(x)	(0x20048 + (x) * 0x1000)
 #define TSI721_SR_CHINT_ODBOK	0x00000020
 #define TSI721_SR_CHINT_IDBQRCV	0x00000010
 #define TSI721_SR_CHINT_SUSP	0x00000008
@@ -156,7 +156,7 @@
 
 #define TSI721_IBWIN_NUM	8
 
-#define TSI721_IBWINLB(x)	(0x29000 + (x) * 20)
+#define TSI721_IBWINLB(x)	(0x29000 + (x) * 0x20)
 #define TSI721_IBWINLB_BA	0xfffff000
 #define TSI721_IBWINLB_WEN	0x00000001
 
@@ -187,13 +187,13 @@
  */
 #define TSI721_OBWIN_NUM	TSI721_PC2SR_WINS
 
-#define TSI721_OBWINLB(x)	(0x40000 + (x) * 20)
+#define TSI721_OBWINLB(x)	(0x40000 + (x) * 0x20)
 #define TSI721_OBWINLB_BA	0xffff8000
 #define TSI721_OBWINLB_WEN	0x00000001
 
-#define TSI721_OBWINUB(x)	(0x40004 + (x) * 20)
+#define TSI721_OBWINUB(x)	(0x40004 + (x) * 0x20)
 
-#define TSI721_OBWINSZ(x)	(0x40008 + (x) * 20)
+#define TSI721_OBWINSZ(x)	(0x40008 + (x) * 0x20)
 #define TSI721_OBWINSZ_SIZE	0x00001f00
 #define TSI721_OBWIN_SIZE(size)	(__fls(size) - 15)
 


