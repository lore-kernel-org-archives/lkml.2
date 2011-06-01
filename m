Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162112Ab1FAIRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162082Ab1FAIRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:23 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:40 2011
Message-Id: <20110601080439.516214497@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:59 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [123/146] sh: fixup fpu.o compile order
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit a375b15164dd9264f724ad941825e52c90145151 upstream.

arch_ptrace() was modified to reference init_fpu() to fix up xstate
initialization, which overlooked the fact that there are configurations
that don't enable any of hard FPU support or emulation, resulting in
build errors on DSP parts.

Given that init_fpu() simply sets up the xstate slab cache and is
side-stepped entirely for the DSP case, we can simply always build in the
helper and fix up the references.

Reported-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/kernel/cpu/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sh/kernel/cpu/Makefile
+++ b/arch/sh/kernel/cpu/Makefile
@@ -17,7 +17,5 @@ obj-$(CONFIG_ARCH_SHMOBILE)	+= shmobile/
 
 obj-$(CONFIG_SH_ADC)		+= adc.o
 obj-$(CONFIG_SH_CLK_CPG_LEGACY)	+= clock-cpg.o
-obj-$(CONFIG_SH_FPU)		+= fpu.o
-obj-$(CONFIG_SH_FPU_EMU)	+= fpu.o
 
-obj-y	+= irq/ init.o clock.o hwblk.o proc.o
+obj-y	+= irq/ init.o clock.o fpu.o hwblk.o proc.o


