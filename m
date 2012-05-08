Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2EHX2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:28:02 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:18665 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHX2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:28:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1336519679!21780809!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: rtf520: las0, las1, and lcfg are void __iomem *
Date: Tue, 8 May 2012 16:27:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205081627.56125.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The las0, las1, and lcfg variables in struct rtdPrivate are all
ioremap'ed pci resources and should be void __iomem *
not void *.

This quiets a lot of sparse warings for the writel and readl like:

warning: incorrect type in argument 1 (different address spaces)
   expected void const volatile [noderef] <asn:2>*addr
   got void *<noident>

warning: incorrect type in argument 2 (different address spaces)
   expected void volatile [noderef] <asn:2>*addr
   got void *

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0c15b82..0e62bae 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -339,9 +339,9 @@ static const struct rtdBoard rtd520Boards[] = {
 */
 struct rtdPrivate {
 	/* memory mapped board structures */
-	void *las0;
-	void *las1;
-	void *lcfg;
+	void __iomem *las0;
+	void __iomem *las1;
+	void __iomem *lcfg;
 
 	unsigned long intCount;	/* interrupt count */
 	long aiCount;		/* total transfer size (samples) */
