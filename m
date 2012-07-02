Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab2GBWqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:46:48 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:34425 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2GBWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:46:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1341269206!8514979!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/12] staging: comedi: das08_cs: remove the pcmcia suspend/resume
Date: Mon, 2 Jul 2012 15:46:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021546.40395.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/das08_cs.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 044c586..b7efcb4 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -184,16 +184,6 @@ static void das08_pcmcia_detach(struct pcmcia_device *link)
 
 }
 
-static int das08_pcmcia_suspend(struct pcmcia_device *link)
-{
-	return 0;
-}
-
-static int das08_pcmcia_resume(struct pcmcia_device *link)
-{
-	return 0;
-}
-
 static const struct pcmcia_device_id das08_cs_id_table[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01c5, 0x4001),
 	PCMCIA_DEVICE_NULL
@@ -205,8 +195,6 @@ static struct pcmcia_driver das08_cs_driver = {
 	.owner		= THIS_MODULE,
 	.probe		= das08_pcmcia_attach,
 	.remove		= das08_pcmcia_detach,
-	.suspend	= das08_pcmcia_suspend,
-	.resume		= das08_pcmcia_resume,
 	.id_table	= das08_cs_id_table,
 };
 
-- 
1.7.11

