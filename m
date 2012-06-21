Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2FUCYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:24:40 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:44224 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2FUCYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:24:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1340245464!6425747!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/12] staging: comedi: s626: pointers should be cleared with NULL not 0
Date: Wed, 20 Jun 2012 19:24:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201924.20348.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdma->LogicalBase is a void *, NULL should be used to clear it not 0.

This quiets a sparse warning about:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 440060b..58c9e40 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2779,7 +2779,7 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 	vpptr = pdma->PhysicalBase;
 	if (vbptr) {
 		pci_free_consistent(devpriv->pdev, bsize, vbptr, vpptr);
-		pdma->LogicalBase = 0;
+		pdma->LogicalBase = NULL;
 		pdma->PhysicalBase = 0;
 
 		DEBUG("CloseDMAB(): Logical=%p, bsize=%d, Physical=0x%x\n",
-- 
1.7.11

