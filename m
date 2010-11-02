Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0KBBxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:53:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50857 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0KBBxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m42Pwy5KolArilEI8RtKCvQAwHVPM4VsRSYUEBwLV3zqmmr59Ei2CzQB0XlyJaR7/T
         8vuL2xNXAVoCKunmNLdg/RYTHDSWNlwHGt/gECvGg9a4eLToAkz/NRTtoYcWGNy0lwbe
         Nq0kSIt/oYJo8LikEEciQlJBG9q5LWQVs+08I=
Subject: [PATCH Resend] dma: imx-dma: fix imxdma_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Pengutronix <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Thiago Farina <tfransosi@gmail.com>
Content-Type: text/plain
Date: Tue, 02 Nov 2010 09:56:11 +0800
Message-Id: <1288662971.20990.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the i variable will be -1 inside the latest iteration of the while loop.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This resend only update the commit log.
Regards,
Axel

 drivers/dma/imx-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index f629e49..e53d438 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -379,7 +379,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	return 0;
 
 err_init:
-	while (i-- >= 0) {
+	while (--i >= 0) {
 		struct imxdma_channel *imxdmac = &imxdma->channel[i];
 		imx_dma_free(imxdmac->imxdma_channel);
 	}
-- 
1.7.2



