Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2EDU5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:57:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab2EDUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:06 -0400
Message-Id: <20120504204246.865253021@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chen Peter-B29397 <B29397@freescale.com>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: [ 23/47] [PATCH] Revert "usb: Fix build error due to dma_mask is not at
 pdev_archdata at ARM"
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit d39514c14bd941232976b68e2750dc725b90e724 which is
e90fc3cb087ce5c5f81e814358222cd6d197b5db upstream as it causes oopses on
some ppc systems.

Reported-by: Chen Peter-B29397 <B29397@freescale.com>
Cc: Ramneek Mehresh <ramneek.mehresh@freescale.com>
Cc: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/fsl-mph-dr-of.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -93,6 +93,7 @@ struct platform_device * __devinit fsl_u
 	pdev->dev.parent = &ofdev->dev;
 
 	pdev->dev.coherent_dma_mask = ofdev->dev.coherent_dma_mask;
+	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
 	*pdev->dev.dma_mask = *ofdev->dev.dma_mask;
 
 	retval = platform_device_add_data(pdev, pdata, sizeof(*pdata));


