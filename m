Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab2HQCrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:47:40 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22557 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2HQCri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:47:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1345171656!14429519!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/35] staging: comedi: cb_pcimdda: remove REG_SZ and REGS_BARINDEX macros
Date: Thu, 16 Aug 2012 19:47:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161947.26427.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The REG_SZ macro isn't being use. Both macros use the 'thisboard'
macro which relys on a local variable having a specific name.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index a801461..04a9d5b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -135,9 +135,6 @@ static const struct board_struct boards[] = {
  */
 #define thisboard    ((const struct board_struct *)dev->board_ptr)
 
-#define REG_SZ (thisboard->reg_sz)
-#define REGS_BADRINDEX (thisboard->regs_badrindex)
-
 /*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
@@ -406,7 +403,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 			}
 			registers =
 			    pci_resource_start(devpriv->pci_dev,
-					       REGS_BADRINDEX);
+					       thisboard->regs_badrindex);
 			devpriv->registers = registers;
 			devpriv->dio_registers
 			    = devpriv->registers + thisboard->dio_offset;
-- 
1.7.11

