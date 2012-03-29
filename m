Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab2C2Qso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779Ab2C2Qsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:48:31 -0400
Date: Thu, 29 Mar 2012 18:48:32 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, acpi/irq: Minor readability cleanup of gsi_to_irq()
Message-ID: <20120329164828.GD21579@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init value of 'irq' variable is never used. So do not initialize it.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 406ed77..f148557 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -103,13 +103,11 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 static unsigned int gsi_to_irq(unsigned int gsi)
 {
-	unsigned int irq = gsi + NR_IRQS_LEGACY;
-	unsigned int i;
+	unsigned int irq;
 
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		if (isa_irq_to_gsi[i] == gsi) {
-			return i;
-		}
+	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+		if (isa_irq_to_gsi[irq] == gsi)
+			return irq;
 	}
 
 	/* Provide an identity mapping of gsi == irq
-- 
1.7.7.6

