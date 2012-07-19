Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2GSB5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:57:42 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54598 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2GSB5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:57:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1342663058!14781437!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 64/90] staging: comedi: daqboard2000: void *plx should be a void __iomem *
Date: Wed, 18 Jul 2012 18:57:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181857.28697.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data variable 'plx' is an ioremap'ed pci resource and
should be a void __iomem *. This quiets a number of sparse warnings
about "different address spaces".

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index ba61e32..ef28385 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -318,7 +318,7 @@ struct daqboard2000_private {
 		card_daqboard_2000
 	} card;
 	void *daq;
-	void *plx;
+	void __iomem *plx;
 	unsigned int ao_readback[2];
 };
 
-- 
1.7.11

