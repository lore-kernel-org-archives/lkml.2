Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab2EVBVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:21:53 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:58657 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2EVBVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:21:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1337649710!7135203!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: s626: base_addr is a void __iomem *
Date: Mon, 21 May 2012 18:21:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201205211821.40209.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base_addr variable in struct s626_private is an ioremap'ed pci
resource and should be void __iomem * not a void *.

This quiets a lot of sparse warings for the writel and readl calls
like:

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

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 7beb8f6..2354586 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -120,7 +120,7 @@ static const struct s626_board s626_boards[] = {
 
 struct s626_private {
 	struct pci_dev *pdev;
-	void *base_addr;
+	void __iomem *base_addr;
 	int got_regions;
 	short allocatedBuf;
 	uint8_t ai_cmd_running;	/*  ai_cmd is running */
