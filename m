Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2F2SAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:00:54 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:47478 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2F2SAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:00:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1340992802!7232615!102
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] staging: comedi: das_08: remove the 8254 'logic2phys' usage
Date: Fri, 29 Jun 2012 11:00:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291100.41204.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three 8254 timers have a 1:1 relationship to the comedi
channels. The 'logic2phys' usage just makes the driver more
complex.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index c0c93ea..2ad66f2 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -448,7 +448,7 @@ static int das08_counter_read(struct comedi_device *dev,
 {
 	struct das08_private_struct *devpriv = dev->private;
 	struct i8254_struct *st = &devpriv->i8254;
-	int chan = st->logic2phys[insn->chanspec];
+	int chan = insn->chanspec;
 
 	data[0] = i8254_read(st->iobase, 0, chan);
 	return 1;
@@ -460,7 +460,7 @@ static int das08_counter_write(struct comedi_device *dev,
 {
 	struct das08_private_struct *devpriv = dev->private;
 	struct i8254_struct *st = &devpriv->i8254;
-	int chan = st->logic2phys[insn->chanspec];
+	int chan = insn->chanspec;
 
 	i8254_write(st->iobase, 0, chan, data[0]);
 	return 1;
@@ -472,7 +472,7 @@ static int das08_counter_config(struct comedi_device *dev,
 {
 	struct das08_private_struct *devpriv = dev->private;
 	struct i8254_struct *st = &devpriv->i8254;
-	int chan = st->logic2phys[insn->chanspec];
+	int chan = insn->chanspec;
 
 	if (insn->n != 2)
 		return -EINVAL;
@@ -848,9 +848,6 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->insn_config = das08_counter_config;
 		/* Set-up the 8254 structure */
 		devpriv->i8254.channels = 3;
-		devpriv->i8254.logic2phys[0] = 0;
-		devpriv->i8254.logic2phys[1] = 1;
-		devpriv->i8254.logic2phys[2] = 2;
 		devpriv->i8254.iobase = iobase + thisboard->i8254_offset;
 		i8254_initialize(&devpriv->i8254);
 	} else {
-- 
1.7.11

