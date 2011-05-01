Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1EAVLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 17:11:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1EAVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 17:10:44 -0400
From: Colin Cross <ccross@android.com>
To: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: tegra: irq: Replace tegra_ack with tegra_eoi
Date: Sun,  1 May 2011 14:10:13 -0700
Message-Id: <1304284213-11950-5-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304284213-11950-1-git-send-email-ccross@android.com>
References: <1304284213-11950-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the GIC flow control function is replaced with
handle_fasteoi_irq, the eoi arch extension will be called
instead of ack.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 1883203..35fb2f10 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -83,7 +83,7 @@ static void tegra_unmask(struct irq_data *d)
 	writel(1 << (leg_irq & 31), base + ICTLR_CPU_IER_SET);
 }
 
-static void tegra_ack(struct irq_data *d)
+static void tegra_eoi(struct irq_data *d)
 {
 	void __iomem *base;
 	int leg_irq;
@@ -121,7 +121,7 @@ void __init tegra_init_irq(void)
 		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
 	}
 
-	gic_arch_extn.irq_ack = tegra_ack;
+	gic_arch_extn.irq_eoi = tegra_eoi;
 	gic_arch_extn.irq_mask = tegra_mask;
 	gic_arch_extn.irq_unmask = tegra_unmask;
 	gic_arch_extn.irq_retrigger = tegra_retrigger;
-- 
1.7.4.1

