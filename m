Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2F2SBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:01:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:25278 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2F2SBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:01:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1340992886!11933045!14
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] staging: comedi: das_08: remove the 8254 'channels' usage
Date: Fri, 29 Jun 2012 11:01:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291101.22815.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal 8254 'channels' count is the same as the comedi
subdevice 'n_chan'. There is no need to keep the internal
count.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 2ad66f2..20f79b7 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -847,7 +847,6 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->insn_write = das08_counter_write;
 		s->insn_config = das08_counter_config;
 		/* Set-up the 8254 structure */
-		devpriv->i8254.channels = 3;
 		devpriv->i8254.iobase = iobase + thisboard->i8254_offset;
 		i8254_initialize(&devpriv->i8254);
 	} else {
-- 
1.7.11

