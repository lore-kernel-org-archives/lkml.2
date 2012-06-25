Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2FYXVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:21:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39463 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2FYXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:21:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340666511!12495743!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/33] staging: comedi: cb_das16_cs: remove the pcmcia suspend/resume
Date: Mon, 25 Jun 2012 16:21:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251621.48251.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia suspend/resume callbacks don't do anything. Remove
them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 151a559..df9b075 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -679,16 +679,6 @@ static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 	cur_dev = NULL;
 }
 
-static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
-{
-	return 0;
-}
-
-static int das16cs_pcmcia_resume(struct pcmcia_device *link)
-{
-	return 0;
-}
-
 static const struct pcmcia_device_id das16cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x0039),
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4009),
@@ -701,8 +691,6 @@ static struct pcmcia_driver das16cs_driver = {
 	.owner		= THIS_MODULE,
 	.probe		= das16cs_pcmcia_attach,
 	.remove		= das16cs_pcmcia_detach,
-	.suspend	= das16cs_pcmcia_suspend,
-	.resume		= das16cs_pcmcia_resume,
 	.id_table	= das16cs_id_table,
 };
 
-- 
1.7.11

