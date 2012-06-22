Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857Ab2FVXfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:35:04 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:54626 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab2FVXfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:35:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1340408101!6566080!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/31] staging: comedi: ni_daq_700: use a local var to fix a > 80 char line issue
Date: Fri, 22 Jun 2012 16:34:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221634.58135.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'data[1] = ...' line is currently kept < 80 chars by breaking a pointer
access after the '->'. This makes the code a bit confusing to follow. Use
a local variable to shorten the line and make it clearer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 4978cd3..2ea3c8d 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -80,6 +80,7 @@ static int subdev_700_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	unsigned int chan = 1 << CR_CHAN(insn->chanspec);
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_INPUT:
@@ -87,10 +88,7 @@ static int subdev_700_insn_config(struct comedi_device *dev,
 	case INSN_CONFIG_DIO_OUTPUT:
 		break;
 	case INSN_CONFIG_DIO_QUERY:
-		data[1] =
-		    (s->
-		     io_bits & (1 << CR_CHAN(insn->chanspec))) ? COMEDI_OUTPUT :
-		    COMEDI_INPUT;
+		data[1] = (s->io_bits & chan) ? COMEDI_OUTPUT : COMEDI_INPUT;
 		return insn->n;
 		break;
 	default:
-- 
1.7.11

