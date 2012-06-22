Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800Ab2FVX0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:26:54 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:64867 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2FVX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:26:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1340407612!12233057!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/31] staging: comedi: ni_daq_700: remove unused private data variable
Date: Fri, 22 Jun 2012 16:26:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221626.47010.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'have_irq' variable is not needed since this driver doesn't
use interrupts. Remove it.

The kfree(s->private) needs to remain to free the memory allocated
in subdev_700_init().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 2f84934..525f076 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -69,7 +69,6 @@ struct dio700_board {
 struct subdev_700_struct {
 	unsigned long cb_arg;
 	int (*cb_func) (int, int, int, unsigned long);
-	int have_irq;
 };
 
 #define CALLBACK_ARG	(((struct subdev_700_struct *)s->private)->cb_arg)
@@ -166,9 +165,7 @@ static void subdev_700_cleanup(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
 {
 	if (s->private)
-		if (subdevpriv->have_irq)
-
-			kfree(s->private);
+		kfree(s->private);
 }
 
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-- 
1.7.11

