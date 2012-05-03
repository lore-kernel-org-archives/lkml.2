Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2ECAiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:38:13 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:59361 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2ECAiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:38:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1336005489!10412605!5
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] video: mb862xxfbdrv.c: local functions should not be exposed globally
Date: Wed, 2 May 2012 17:37:35 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <FlorianSchandinat@gmx.de>, <agust@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021737.35719.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent them from being exposed globally.

Quiets the sparse warnings:

warning: symbol 'mb862xx_intr' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>

---

diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
index 11a7a33..00ce1f3 100644
--- a/drivers/video/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -579,7 +579,7 @@ static ssize_t mb862xxfb_show_dispregs(struct device *dev,
 
 static DEVICE_ATTR(dispregs, 0444, mb862xxfb_show_dispregs, NULL);
 
-irqreturn_t mb862xx_intr(int irq, void *dev_id)
+static irqreturn_t mb862xx_intr(int irq, void *dev_id)
 {
 	struct mb862xxfb_par *par = (struct mb862xxfb_par *) dev_id;
 	unsigned long reg_ist, mask;
