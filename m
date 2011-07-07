Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1GGTKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:10:52 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:55302 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1GGTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:10:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/10] xen/pci: Use 'acpi_gsi_to_irq' value unconditionally.
Date: Thu,  7 Jul 2011 15:08:26 -0400
Message-Id: <1310065706-18797-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E160438.002B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past we would only use the function's value if the
returned value was not equal to 'acpi_sci_override_gsi'. Meaning
that the INT_SRV_OVR values for global and source irq were different.
But it is OK to use the function's value even when the global
and source irq are the same.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index f07c419..1017c7b 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -407,10 +407,9 @@ static __init void xen_setup_acpi_sci(void)
 	 * the ACPI interpreter and keels over since IRQ 9 has not been
 	 * setup as we had setup IRQ 20 for it).
 	 */
-	/* Check whether the GSI != IRQ */
 	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
-		if (irq >= 0 && irq != gsi)
-			/* Bugger, we MUST have that IRQ. */
+		/* Use the provided value if it's valid. */
+		if (irq >= 0)
 			gsi_override = irq;
 	}
 
-- 
1.7.4.1

