Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2FLS5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:57:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:49993 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2FLS5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:57:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1339527431!8260051!58
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] staging: comedi: change type of num_subdevices parameter to comedi_alloc_subdevices
Date: Tue, 12 Jun 2012 11:57:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121157.27498.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 606739d47df00ac9767e3256ab8f6eb1572bd429 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 09:45:17 -0700
Subject: [PATCH 2/8] staging: comedi: change type of num_subdevices parameter
 to comedi_alloc_subdevices

The n_subdevices variable of struct comedi_device is an int type.
Change the type of the comedi_alloc_subdevices 'num_subdevices' from
an unsigned int to an int to match it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h |    2 +-
 drivers/staging/comedi/drivers.c   |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index bb98f82..e0f3915 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -292,7 +292,7 @@ static inline struct comedi_subdevice *comedi_get_write_subdevice(
 	return info->device->write_subdev;
 }
 
-int comedi_alloc_subdevices(struct comedi_device *, unsigned int);
+int comedi_alloc_subdevices(struct comedi_device *, int);
 
 void comedi_device_detach(struct comedi_device *dev);
 int comedi_device_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index cce7521..87a87dd 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -56,10 +56,9 @@ static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s);
 
 struct comedi_driver *comedi_drivers;
 
-int comedi_alloc_subdevices(struct comedi_device *dev,
-			    unsigned int num_subdevices)
+int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 {
-	unsigned i;
+	int i;
 
 	dev->n_subdevices = num_subdevices;
 	dev->subdevices =
-- 
1.7.7

