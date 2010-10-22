Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0JVTUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:20:11 -0400
Received: from kroah.org ([198.145.64.141]:33993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab0JVS4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.297656494@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [022/103] ARM: 6395/1: VExpress: Set bit 22 in the PL310 (cache controller) AuxCtlr register
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 1a8e41cd672f894bbd74874eac601e6cedf838fb upstream.

Clearing bit 22 in the PL310 Auxiliary Control register (shared
attribute override enable) has the side effect of transforming Normal
Shared Non-cacheable reads into Cacheable no-allocate reads.

Coherent DMA buffers in Linux always have a Cacheable alias via the
kernel linear mapping and the processor can speculatively load cache
lines into the PL310 controller. With bit 22 cleared, Non-cacheable
reads would unexpectedly hit such cache lines leading to buffer
corruption.

Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-vexpress/ct-ca9x4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -225,7 +225,7 @@ static void ct_ca9x4_init(void)
 	int i;
 
 #ifdef CONFIG_CACHE_L2X0
-	l2x0_init(MMIO_P2V(CT_CA9X4_L2CC), 0x00000000, 0xfe0fffff);
+	l2x0_init(MMIO_P2V(CT_CA9X4_L2CC), 0x00400000, 0xfe0fffff);
 #endif
 
 	clkdev_add_table(lookups, ARRAY_SIZE(lookups));


