Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2GXAWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 20:22:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39655 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2GXAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 20:22:05 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@simtec.co.uk,
        "Du, Changbin" <changbin.du@gmail.com>
Subject: [Resend PATCH v2] usb: gadget: s3c-hsotg: fix core reset timeout failure
Date: Tue, 24 Jul 2012 08:19:25 +0800
Message-Id: <1343089166-5657-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120723104145.GR8265@arwen.pp.htv.fi>
References: <20120723104145.GR8265@arwen.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

The timeout values were 1000 and timeout issue occured many times on my
s3c6410 Soc based board (mostly when booting whith USB cable not
connected). This patch increase the values to 10000 to guarantee the
success of reset.

Having set timeout to 10000, I printed the remained timeout values
which could cause timeout issue before this change (tested several
times).
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
Seeing from above values, I think the value 10000 is big enough.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
Changes for v2:
	Fixed wrapped line done by my mail client

---
 drivers/usb/gadget/s3c-hsotg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index f4abb0e..f3e2234 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg *hsotg)
 	/* issue soft reset */
 	writel(GRSTCTL_CSftRst, hsotg->regs + GRSTCTL);
 
-	timeout = 1000;
+	timeout = 10000;
 	do {
 		grstctl = readl(hsotg->regs + GRSTCTL);
 	} while ((grstctl & GRSTCTL_CSftRst) && timeout-- > 0);
@@ -2225,7 +2225,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg *hsotg)
 		return -EINVAL;
 	}
 
-	timeout = 1000;
+	timeout = 10000;
 
 	while (1) {
 		u32 grstctl = readl(hsotg->regs + GRSTCTL);
-- 
1.7.9.5

