Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803Ab2FVXS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:18:58 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:48034 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762784Ab2FVXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:18:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1340407135!7533935!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/31] staging: comedi: ni_daq_700: Remove the unused private data struct
Date: Fri, 22 Jun 2012 16:18:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221618.52368.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data struct in this driver is not used for anything.
Remove the struct definition and the alloc_private() call.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index b851e2e..7ad5465 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -90,13 +90,6 @@ static const struct dio700_board dio700_boards[] = {
  */
 #define thisboard ((const struct dio700_board *)dev->board_ptr)
 
-struct dio700_private {
-
-	int data;		/* number of data points left to be taken */
-};
-
-#define devpriv ((struct dio700_private *)dev->private)
-
 #define _700_SIZE 8
 
 #define _700_DATA 0
@@ -227,10 +220,6 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pcmcia_device *link;
 	int ret;
 
-	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct dio700_private)) < 0)
-		return -ENOMEM;
-
 	/*  get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
 	case pcmcia_bustype:
-- 
1.7.11

