Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2GBWoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:44:39 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:62458 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2GBWoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:44:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1341269076!7586689!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/12] staging: comedi: das08_cs: cleanup the pcmcia_driver declaration
Date: Mon, 2 Jul 2012 15:44:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021544.31238.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, add some whitespace to the declaration
of the pcmcia_driver and reorder it a bit.

Also, the symbol 'das08_cs_driver' is only referenced in this file,
make it static. This quiets the following sparse warning:

warning: symbol 'das08_cs_driver' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 493078a..de094ad 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -225,14 +225,14 @@ static const struct pcmcia_device_id das08_cs_id_table[] = {
 
 MODULE_DEVICE_TABLE(pcmcia, das08_cs_id_table);
 
-struct pcmcia_driver das08_cs_driver = {
-	.probe = das08_pcmcia_attach,
-	.remove = das08_pcmcia_detach,
-	.suspend = das08_pcmcia_suspend,
-	.resume = das08_pcmcia_resume,
-	.id_table = das08_cs_id_table,
-	.owner = THIS_MODULE,
-	.name = "pcm-das08",
+static struct pcmcia_driver das08_cs_driver = {
+	.name		= "pcm-das08",
+	.owner		= THIS_MODULE,
+	.probe		= das08_pcmcia_attach,
+	.remove		= das08_pcmcia_detach,
+	.suspend	= das08_pcmcia_suspend,
+	.resume		= das08_pcmcia_resume,
+	.id_table	= das08_cs_id_table,
 };
 
 static int __init das08_cs_init_module(void)
-- 
1.7.11

