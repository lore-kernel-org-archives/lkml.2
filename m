Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab2GCCDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:03:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48252 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2GCCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:03:19 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: <balbi@ti.com>
Cc: <gregkh@linuxfoundation.org>, <ben@simtec.co.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] usb: gadget: s3c-hsotg: fix core reset timeout failure
Date: Tue, 3 Jul 2012 10:03:11 +0800
Message-ID: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AQHNWL4QEBFbzxlGt0uqOw+bSPx0L5cWysiQgAABCjA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeout values were 1000 and timeout issue occured many times on my
s3c6410 Soc based board (mostly when booting whith USB cable not
connected). This patch increase the values to 10000 to guarantee the
success of reset.

Having set timeout to 10000, I printed the remained timeout values
which can cause timeout issue before this change (tested several times):
the first timeout value remained:
	timeout = 8079
	timeout = 8079
	timeout = 8078
	timeout = 8081
the second timeout value remained:
	timeout = 7940
	timeout = 7945
	timeout = 7940
	timeout = 7938
Seeing from above values, I think 10000 is big enough.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index f4abb0e..f3e2234 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
*hsotg)
 	/* issue soft reset */
 	writel(GRSTCTL_CSftRst, hsotg->regs + GRSTCTL);
 
-	timeout = 1000;
+	timeout = 10000;
 	do {
 		grstctl = readl(hsotg->regs + GRSTCTL);
 	} while ((grstctl & GRSTCTL_CSftRst) && timeout-- > 0);
@@ -2225,7 +2225,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
*hsotg)
 		return -EINVAL;
 	}
 
-	timeout = 1000;
+	timeout = 10000;
 
 	while (1) {
 		u32 grstctl = readl(hsotg->regs + GRSTCTL);
-- 
1.7.9.5


