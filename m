Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1BPAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:15 -0500
Received: from kroah.org ([198.145.64.141]:49302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542Ab1BPAXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.435958689@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changhwan Youn <chaos.youn@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [173/272] ARM: S5PV310: Set bit 22 in the PL310 (cache controller) AuxCtlr register
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Changhwan Youn <chaos.youn@samsung.com>

commit a50eb1c7680973f5441ca20ac4da0af2055d0d87 upstream.

This patch is applied according to the commit 1a8e41cd672f894bbd74874eac601e6cedf838fb
(ARM: 6395/1: VExpress: Set bit 22 in the PL310 (cache controller) AuxCtlr register).

Actually, S5PV310 has same cache controller(PL310).

Following is from Catalin Marinas' commit.

Clearing bit 22 in the PL310 Auxiliary Control register (shared
attribute override enable) has the side effect of transforming Normal
Shared Non-cacheable reads into Cacheable no-allocate reads.

Coherent DMA buffers in Linux always have a Cacheable alias via the
kernel linear mapping and the processor can speculatively load cache
lines into the PL310 controller. With bit 22 cleared, Non-cacheable
reads would unexpectedly hit such cache lines leading to buffer
corruption.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-s5pv310/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-s5pv310/cpu.c
+++ b/arch/arm/mach-s5pv310/cpu.c
@@ -168,7 +168,7 @@ static int __init s5pv310_l2x0_cache_ini
 	__raw_writel(L2X0_DYNAMIC_CLK_GATING_EN | L2X0_STNDBY_MODE_EN,
 		     S5P_VA_L2CC + L2X0_POWER_CTRL);
 
-	l2x0_init(S5P_VA_L2CC, 0x7C070001, 0xC200ffff);
+	l2x0_init(S5P_VA_L2CC, 0x7C470001, 0xC200ffff);
 
 	return 0;
 }


