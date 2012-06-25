Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab2FYXU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:20:58 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:5559 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab2FYXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:20:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1340666438!6924045!4
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/33] staging: comedi: cb_das16_cs: remove unused pcmcia 'stop' logic
Date: Mon, 25 Jun 2012 16:20:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251620.36895.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcmcia support code in this driver appears to be cut-and-
paste from some other driver. It has code in it to stop the
device during suspend but nothing in the main comedi_driver
uses it.

Remove the 'stop' variable from the pcmcia private data and
all the logic that deals with it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 5171cfe..151a559 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -625,7 +625,6 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 
 struct local_info_t {
 	struct pcmcia_device *link;
-	int stop;
 	struct bus_operations *bus;
 };
 
@@ -674,7 +673,6 @@ failed:
 
 static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 {
-	((struct local_info_t *)link->priv)->stop = 1;
 	pcmcia_disable_device(link);
 	/* This points to the parent struct local_info_t struct */
 	kfree(link->priv);
@@ -683,19 +681,11 @@ static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 
 static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-
-	/* Mark the device as stopped, to block IO until later */
-	local->stop = 1;
-
 	return 0;
 }
 
 static int das16cs_pcmcia_resume(struct pcmcia_device *link)
 {
-	struct local_info_t *local = link->priv;
-
-	local->stop = 0;
 	return 0;
 }
 
-- 
1.7.11

