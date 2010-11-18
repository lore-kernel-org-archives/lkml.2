Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0KRK0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:26:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49557 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0KRK0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=lQaYczvhXqDwqhmAHI0NwdZgi5rLifXyYrZJ3d+vtM2fmODQKmeZ8OM9nGlYYNrlC6
         GL8qkk+sB6TQxoNGovB/h+Ctz5G4+HSCFjf+fzV50arBdsWOAEcYysoMvYxX+8A+dt1s
         cOLkjmSuVuezbqlLyr3Wweic2Do6VhnNv66+0=
Subject: [PATCH] Fix MSP71xx bpci interrupt handler return value
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Ben Hutchings <ben@decadent.org.uk>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 16:02:50 +0530
Message-ID: <1290076370.31469.1.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pci/ops-pmcmsp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index b7c03d8..68798f8 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -308,7 +308,7 @@ static struct resource pci_mem_resource = {
  *  RETURNS:     PCIBIOS_SUCCESSFUL  - success
  *

****************************************************************************/
-static int bpci_interrupt(int irq, void *dev_id)
+static irqreturn_t bpci_interrupt(int irq, void *dev_id)
 {
 	struct msp_pci_regs *preg = (void *)PCI_BASE_REG;
 	unsigned int stat = preg->if_status;
@@ -326,7 +326,7 @@ static int bpci_interrupt(int irq, void *dev_id)
 	/* write to clear all asserted interrupts */
 	preg->if_status = stat;
 
-	return PCIBIOS_SUCCESSFUL;
+	return IRQ_HANDLED;
 }
 
 /*****************************************************************************
-- 
1.7.0.4



