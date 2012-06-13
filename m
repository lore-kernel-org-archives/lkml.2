Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2FMWov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:44:51 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52060 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2FMWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:41:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1339627291!9413118!13
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/15] staging: comedi: 8255: rename the private data structure
Date: Wed, 13 Jun 2012 15:41:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131541.36853.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the 8255's private data structure from subdev_8255_struct
to subdev_8255_private.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 23b9acc..446dfc5 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -97,15 +97,15 @@ I/O port base address can be found in the output of 'lspci -v'.
 #define CR_A_MODE(a)	((a)<<5)
 #define CR_CW		0x80
 
-struct subdev_8255_struct {
+struct subdev_8255_private {
 	unsigned long cb_arg;
 	int (*cb_func) (int, int, int, unsigned long);
 	int have_irq;
 };
 
-#define CALLBACK_ARG	(((struct subdev_8255_struct *)s->private)->cb_arg)
-#define CALLBACK_FUNC	(((struct subdev_8255_struct *)s->private)->cb_func)
-#define subdevpriv	((struct subdev_8255_struct *)s->private)
+#define CALLBACK_ARG	(((struct subdev_8255_private *)s->private)->cb_arg)
+#define CALLBACK_FUNC	(((struct subdev_8255_private *)s->private)->cb_func)
+#define subdevpriv	((struct subdev_8255_private *)s->private)
 
 void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
@@ -316,7 +316,7 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	s->range_table = &range_digital;
 	s->maxdata = 1;
 
-	s->private = kmalloc(sizeof(struct subdev_8255_struct), GFP_KERNEL);
+	s->private = kmalloc(sizeof(struct subdev_8255_private), GFP_KERNEL);
 	if (!s->private)
 		return -ENOMEM;
 
-- 
1.7.7

