Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2FMWnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:43:18 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:9443 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2FMWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:43:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1339627390!11350107!8
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/15] staging: comedi: 8255: move the subdev_8255_io function
Date: Wed, 13 Jun 2012 15:42:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.52031.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subdev_8255_interrupt function indirectly calls subdev_8255_io.
For aesthetic reasons, move the subdev_8255_io function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index da374de..abbb6d4 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -102,6 +102,16 @@ struct subdev_8255_private {
 	int (*io) (int, int, int, unsigned long);
 };
 
+static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
+{
+	if (dir) {
+		outb(data, iobase + port);
+		return 0;
+	} else {
+		return inb(iobase + port);
+	}
+}
+
 void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
@@ -119,16 +129,6 @@ void subdev_8255_interrupt(struct comedi_device *dev,
 }
 EXPORT_SYMBOL(subdev_8255_interrupt);
 
-static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
-{
-	if (dir) {
-		outb(data, iobase + port);
-		return 0;
-	} else {
-		return inb(iobase + port);
-	}
-}
-
 static int subdev_8255_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
-- 
1.7.7

