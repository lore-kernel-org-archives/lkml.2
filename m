Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2FVXdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:33:31 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39914 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2FVXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:33:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1340408009!12245572!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/31] staging: comedi: ni_daq_700: remove local variable in the 'attach' function
Date: Fri, 22 Jun 2012 16:33:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221633.11268.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for the local variable 'iobase' in the attach
function. If it's '0' the attach fails otherwise the value is
just stored in dev->iobase.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 50fad12..5c60df8 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -104,22 +104,19 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dio700_board *thisboard = comedi_board(dev);
 	struct comedi_subdevice *s;
-	unsigned long iobase = 0;
 	struct pcmcia_device *link;
 	int ret;
 
 	link = pcmcia_cur_dev;	/* XXX hack */
 	if (!link)
 		return -EIO;
-	iobase = link->resource[0]->start;
 
-	if (iobase == 0) {
+	dev->iobase = link->resource[0]->start;
+	if (!dev->iobase) {
 		dev_err(dev->class_dev, "io base address is zero!\n");
 		return -EINVAL;
 	}
 
-	dev->iobase = iobase;
-
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-- 
1.7.11

