Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2FYW55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:57:57 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:15579 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2FYW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:57:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1340665074!12487120!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/33] staging: comedi: cb_das16_cs: cleanup the pcmcia_driver declaration
Date: Mon, 25 Jun 2012 15:57:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251557.49993.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, add some whitespace to the declaration
of the pcmcia_driver and reorder it a bit.

Also, the symbol 'das16cs_driver' is only referenced in this file,
make it static. This quiets the following sparse warning:

warning: symbol 'das16cs_driver' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 625134f..2ac30f4 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -770,14 +770,14 @@ static const struct pcmcia_device_id das16cs_id_table[] = {
 
 MODULE_DEVICE_TABLE(pcmcia, das16cs_id_table);
 
-struct pcmcia_driver das16cs_driver = {
-	.probe = das16cs_pcmcia_attach,
-	.remove = das16cs_pcmcia_detach,
-	.suspend = das16cs_pcmcia_suspend,
-	.resume = das16cs_pcmcia_resume,
-	.id_table = das16cs_id_table,
-	.owner = THIS_MODULE,
-	.name = "cb_das16_cs",
+static struct pcmcia_driver das16cs_driver = {
+	.name		= "cb_das16_cs",
+	.owner		= THIS_MODULE,
+	.probe		= das16cs_pcmcia_attach,
+	.remove		= das16cs_pcmcia_detach,
+	.suspend	= das16cs_pcmcia_suspend,
+	.resume		= das16cs_pcmcia_resume,
+	.id_table	= das16cs_id_table,
 };
 
 static int __init das16cs_init(void)
-- 
1.7.11

