Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2F0BDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:03:41 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:13000 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2F0BDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:03:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1340759017!23377017!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/36] staging: comedi: cb_pcidas: check for failure of subdev_8255_init
Date: Tue, 26 Jun 2012 18:03:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261803.34491.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for subdev_8255_init() to fail due to its kzalloc().
Make sure to check for this failure and pass on the error code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9379d25..a033071 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1640,7 +1640,10 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 
 	/* 8255 */
 	s = dev->subdevices + 2;
-	subdev_8255_init(dev, s, NULL, devpriv->pacer_counter_dio + DIO_8255);
+	ret = subdev_8255_init(dev, s, NULL,
+			       devpriv->pacer_counter_dio + DIO_8255);
+	if (ret)
+		return ret;
 
 	/*  serial EEPROM, */
 	s = dev->subdevices + 3;
-- 
1.7.11

