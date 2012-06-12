Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2FLS5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:57:53 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:48973 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2FLS5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:57:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1339527465!22015979!12
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] staging: comedi: sanity check num_subdevices parameter in comedi_alloc_subdevices
Date: Tue, 12 Jun 2012 11:57:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121157.46035.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 952298d9ff21bc8fba3ece36a634a7abad89d912 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 09:53:02 -0700
Subject: [PATCH 3/8] staging: comedi: sanity check num_subdevices parameter
 in comedi_alloc_subdevices

It's possible for a couple of the comedi drivers to incorrectly call
comedi_alloc_subdevices with num_subdevices = 0. Add a sanity check
before doing the kcalloc.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbot@mev.co.uk>
Cc: Frank Mori Hess <kmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 87a87dd..4d5da37 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -60,6 +60,8 @@ int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 {
 	int i;
 
+	if (num_subdevices < 1)
+		return -EINVAL;
 	dev->n_subdevices = num_subdevices;
 	dev->subdevices =
 	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
-- 
1.7.7

