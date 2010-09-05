Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0IENFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:05:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0IENFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:05:07 -0400
Date: Sun, 5 Sep 2010 13:04:37 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fujita.tomonori@lab.ntt.co.jp, airlied@redhat.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, airlied@redhat.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1283531981-7495-2-git-send-email-bp@amd64.org>
References: <1283531981-7495-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86, GART: Remove superfluous AMD64_GARTEN
Message-ID: <tip-57ab43e33122ffdc2eebca5d6de035699f0a8c06@git.kernel.org>
Git-Commit-ID: 57ab43e33122ffdc2eebca5d6de035699f0a8c06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:04:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57ab43e33122ffdc2eebca5d6de035699f0a8c06
Gitweb:     http://git.kernel.org/tip/57ab43e33122ffdc2eebca5d6de035699f0a8c06
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 3 Sep 2010 18:39:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:28:34 +0200

x86, GART: Remove superfluous AMD64_GARTEN

There is a GARTEN so use that and drop the duplicate.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1283531981-7495-2-git-send-email-bp@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
