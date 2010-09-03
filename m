Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0ICQjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:39:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56700 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0ICQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:39:51 -0400
From: Borislav Petkov <bp@amd64.org>
To: Dave Airlie <airlied@redhat.com>, <hpa@zytor.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] x86, GART: Remove superfluous AMD64_GARTEN
Date: Fri,  3 Sep 2010 18:39:39 +0200
Message-Id: <1283531981-7495-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283531981-7495-1-git-send-email-bp@amd64.org>
References: <1283531981-7495-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

There is a GARTEN so use that and drop the duplicate.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/gart.h   |    1 -
 arch/x86/kernel/aperture_64.c |    4 ++--
 drivers/char/agp/amd64-agp.c  |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 4ac5b0f..fba0a72 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -27,7 +27,6 @@ extern int fix_aperture;
 #define AMD64_GARTAPERTUREBASE	0x94
 #define AMD64_GARTTABLEBASE	0x98
 #define AMD64_GARTCACHECTL	0x9c
-#define AMD64_GARTEN		(1<<0)
 
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index a2e0caf..6fabd40 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -307,7 +307,7 @@ void __init early_gart_iommu_check(void)
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
-			aper_enabled = ctl & AMD64_GARTEN;
+			aper_enabled = ctl & GARTEN;
 			aper_order = (ctl >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
@@ -362,7 +362,7 @@ void __init early_gart_iommu_check(void)
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
-			ctl &= ~AMD64_GARTEN;
+			ctl &= ~GARTEN;
 			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
 		}
 	}
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 70312da..bfe372b 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -199,7 +199,7 @@ static void amd64_cleanup(void)
 		struct pci_dev *dev = k8_northbridges[i];
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
-		tmp &= ~AMD64_GARTEN;
+		tmp &= ~GARTEN;
 		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, tmp);
 	}
 }
-- 
1.7.1

