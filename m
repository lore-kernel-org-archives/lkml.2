Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2FHAOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:14:32 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:30243 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2FHAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:14:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1339114469!21809706!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: serial2002: quiet NULL pointer sparse noise
Date: Thu, 7 Jun 2012 17:14:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206071714.25934.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet a number of sparse warnings in this file:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 9200310..c25808c 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -643,7 +643,7 @@ err_alloc_configs:
 
 		if (result) {
 			if (devpriv->tty) {
-				filp_close(devpriv->tty, 0);
+				filp_close(devpriv->tty, NULL);
 				devpriv->tty = NULL;
 			}
 		}
@@ -653,8 +653,8 @@ err_alloc_configs:
 
 static void serial_2002_close(struct comedi_device *dev)
 {
-	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0))
-		filp_close(devpriv->tty, 0);
+	if (!IS_ERR(devpriv->tty) && devpriv->tty)
+		filp_close(devpriv->tty, NULL);
 }
 
 static int serial2002_di_rinsn(struct comedi_device *dev,
@@ -819,7 +819,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_read = &serial2002_ai_rinsn;
 
 	/* analog output subdevice */
@@ -828,7 +828,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_write = &serial2002_ao_winsn;
 	s->insn_read = &serial2002_ao_rinsn;
 
@@ -838,7 +838,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_READABLE | SDF_LSAMPL;
 	s->n_chan = 0;
 	s->maxdata = 1;
-	s->range_table = 0;
+	s->range_table = NULL;
 	s->insn_read = &serial2002_ei_rinsn;
 
 	return 1;
