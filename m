Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2F0WE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:04:59 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:41518 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2F0WE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:04:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340834687!7976168!11
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/19] staging: comedi: adl_pci6208: fix the ao_readback variable size
Date: Wed, 27 Jun 2012 15:04:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271504.48007.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'ao_readback' variable in the private data struct is used to
cache the last value written to the analog output DAC channels.
The PCI-6208 has 8 analog output channels but the variable only
allowed space to cache 2 values.

Since the PCI-6216 board could be supported by this driver and
it has 16 analog outputs, create a define for the maximum number
of channels and use that to set the size of 'ao_readback'.

For now, set the max to 8 to save space since the PCI-6216 is
not currently supported.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index dcaebfc..d15f0cb 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -56,6 +56,8 @@ References:
 #define PCI6208_DIO_DI_MASK		(0xf0)
 #define PCI6208_DIO_DI_SHIFT		(4)
 
+#define PCI6208_MAX_AO_CHANNELS		8
+
 struct pci6208_board {
 	const char *name;
 	unsigned short dev_id;
@@ -72,7 +74,7 @@ static const struct pci6208_board pci6208_boards[] = {
 
 struct pci6208_private {
 	struct pci_dev *pci_dev;
-	unsigned int ao_readback[2];
+	unsigned int ao_readback[PCI6208_MAX_AO_CHANNELS];
 };
 
 static int pci6208_ao_winsn(struct comedi_device *dev,
-- 
1.7.11

