Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0JOF1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:27:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59636 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0JOF1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O7JHqAx4o34COce1Fonf4AWoOtWf/4kTEccer95RShztiGPN7xLyR4R3slUaYOlORI
         IBI5tT/ayd8i16HyxqabyGcxr1ZU2jzqPYS0aOuVj3P7AbMg/9nlvU3jASBr5WvsLlDB
         R834CADiFVhznqqlAwefHQQiMqCz/b3kNGnDA=
Subject: [PATCH 3/3] USB: ohci-sh - use resource_size instead of defining
	its own resource_len macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
In-Reply-To: <1287120381.20429.1.camel@mola>
References: <1287120381.20429.1.camel@mola>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 13:29:24 +0800
Message-Id: <1287120564.20429.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/host/ohci-sh.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-sh.c b/drivers/usb/host/ohci-sh.c
index 60f03cc..0b35d22 100644
--- a/drivers/usb/host/ohci-sh.c
+++ b/drivers/usb/host/ohci-sh.c
@@ -77,7 +77,6 @@ static const struct hc_driver ohci_sh_hc_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-#define resource_len(r) (((r)->end - (r)->start) + 1)
 static int ohci_hcd_sh_probe(struct platform_device *pdev)
 {
 	struct resource *res = NULL;
@@ -109,7 +108,7 @@ static int ohci_hcd_sh_probe(struct platform_device *pdev)
 
 	hcd->regs = (void __iomem *)res->start;
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_len(res);
+	hcd->rsrc_len = resource_size(res);
 	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
 	if (ret != 0) {
 		err("Failed to add hcd");
-- 
1.7.2



