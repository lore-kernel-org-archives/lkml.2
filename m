Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2F0WH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:07:27 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:58701 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0WHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:07:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1340834843!7016843!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/19] staging: comedi: adl_pci6208: cleanup pci6208_ao_rinsn()
Date: Wed, 27 Jun 2012 15:07:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271507.06072.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, reorder the local variables and change
the return value to 'insn->n'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 7120878..aa2db5d 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -107,13 +107,13 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci6208_private *devpriv = dev->private;
-	int i;
 	int chan = CR_CHAN(insn->chanspec);
+	int i;
 
 	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
 
-	return i;
+	return insn->n;
 }
 
 static int pci6208_dio_insn_bits(struct comedi_device *dev,
-- 
1.7.11

