Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1LGQsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:48:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab1LGQUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.333603538@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:21 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Ming Lei <tom.leiming@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [019/104] ARM: OMAP2: select ARM_AMBA if OMAP3_EMU is defined
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit a8a6565c7615cab3608d75af95b5c8a3522cd7c4 upstream.

This patch selects ARM_AMBA if OMAP3_EMU is defined because
OC_ETM depends on ARM_AMBA, so fix the link failure[1].

[1],
arch/arm/kernel/built-in.o: In function `etm_remove':
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:609: undefined
reference to `amba_release_regions'
arch/arm/kernel/built-in.o: In function `etb_remove':
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:409: undefined
reference to `amba_release_regions'
arch/arm/kernel/built-in.o: In function `etm_init':
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:640: undefined
reference to `amba_driver_register'
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:646: undefined
reference to `amba_driver_register'
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:648: undefined
reference to `amba_driver_unregister'
arch/arm/kernel/built-in.o: In function `etm_probe':
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:545: undefined
reference to `amba_request_regions'
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:595: undefined
reference to `amba_release_regions'
arch/arm/kernel/built-in.o: In function `etb_probe':
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:347: undefined
reference to `amba_request_regions'
/home/tom/git/omap/linux-2.6-omap/arch/arm/kernel/etm.c:392: undefined
reference to `amba_release_regions'
arch/arm/mach-omap2/built-in.o: In function `emu_init':
/home/tom/git/omap/linux-2.6-omap/arch/arm/mach-omap2/emu.c:62:
undefined reference to `amba_device_register'
/home/tom/git/omap/linux-2.6-omap/arch/arm/mach-omap2/emu.c:63:
undefined reference to `amba_device_register'
make: *** [.tmp_vmlinux1] Error 1
making modules

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -329,6 +329,7 @@ config MACH_OMAP4_PANDA
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
+	select ARM_AMBA
 	select OC_ETM
 	help
 	  Say Y here to enable debugging hardware of omap3


