Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0CVAg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:36:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53190 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0CVAg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:36:57 -0400
To: Julia Lawall <julia@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
	<1267697339-5491-7-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
	<4B900250.8020100@kernel.org>
	<Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
	<m1eije71et.fsf@fess.ebiederm.org>
	<Pine.LNX.4.64.1003212035220.12371@ask.diku.dk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 21 Mar 2010 17:36:51 -0700
In-Reply-To: <Pine.LNX.4.64.1003212035220.12371@ask.diku.dk> (Julia Lawall's message of "Sun\, 21 Mar 2010 20\:36\:35 +0100 \(CET\)")
Message-ID: <m11vfdyyxo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: julia@diku.dk, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> Here is the list of potential trouble spots.  This is from a slightly 
> older version of Linux than the patch, so the line numbers don't match up.  
> But the function names are probably good enough to find the problem.

Thanks for doing all of this.  The set of trouble spots in particular
looks like a useful list.

> julia
>
> function definition not found:
>  arch/arm/mach-iop13xx/msi.c::167: unmask_msi_irq
>  arch/arm/mach-iop13xx/msi.c::168: mask_msi_irq
>  arch/arm/mach-iop13xx/msi.c::169: mask_msi_irq
>  arch/arm/mach-iop13xx/msi.c::170: unmask_msi_irq
>  arch/arm/mach-s3c2410/bast-irq.c::109: bast_pc104_maskack
>  arch/arm/mach-s3c2412/irq.c::108: s3c_irq_wake
>  arch/arm/mach-s3c2412/irq.c::109: s3c_irqext_type
>  arch/arm/mach-s3c64xx/irq-eint.c::148: s3c_irqext_wake
>  arch/arm/plat-s3c24xx/irq.c::241: s3c_irqext_wake
>  arch/arm/plat-s3c24xx/irq.c::249: s3c_irq_wake
>  arch/arm/plat-s3c24xx/irq.c::91: s3c_irq_wake
>  arch/arm/plat-s3c24xx/irq.c::99: s3c_irq_wake
>  arch/arm/plat-s5pc1xx/irq-eint.c::179: s3c_irqext_wake
>  arch/arm/plat-s5pc1xx/irq-eint.c::257: s3c_irqext_wake
>  arch/frv/kernel/irq-mb93093.c::76: frv_fpga_end
>  arch/ia64/kernel/iosapic.c::425: iosapic_shutdown_level_irq
>  arch/ia64/kernel/iosapic.c::426: iosapic_enable_level_irq
>  arch/ia64/kernel/iosapic.c::427: iosapic_disable_level_irq
>  arch/ia64/kernel/iosapic.c::428: iosapic_ack_level_irq
>  arch/ia64/kernel/iosapic.c::475: iosapic_disable_edge_irq
>  arch/ia64/kernel/iosapic.c::476: iosapic_enable_edge_irq
>  arch/ia64/kernel/iosapic.c::477: iosapic_disable_edge_irq
>  arch/ia64/kernel/iosapic.c::479: iosapic_end_edge_irq
>  arch/ia64/kernel/msi_ia64.c::107: mask_msi_irq
>  arch/ia64/kernel/msi_ia64.c::108: unmask_msi_irq
>  arch/ia64/kernel/msi_ia64.c::163: dmar_msi_unmask
>  arch/ia64/kernel/msi_ia64.c::164: dmar_msi_mask
>  arch/ia64/sn/kernel/irq.c::280: sn_set_affinity_irq
>  arch/ia64/sn/kernel/msi_sn.c::230: mask_msi_irq
>  arch/ia64/sn/kernel/msi_sn.c::231: unmask_msi_irq
>  arch/m68knommu/platform/coldfire/intc.c::187: intc_irq_unmask
>  arch/mips/dec/ioasic-irq.c::86: ack_ioasic_dma_irq
>  arch/mips/dec/ioasic-irq.c::87: mask_ioasic_dma_irq
>  arch/mips/dec/ioasic-irq.c::88: ack_ioasic_dma_irq
>  arch/mips/dec/ioasic-irq.c::89: unmask_ioasic_dma_irq
>  arch/mips/kernel/i8259.c::45: plat_set_irq_affinity
>  arch/mips/kernel/irq_cpu.c::94: mask_mips_mt_irq
>  arch/mips/kernel/irq_cpu.c::96: unmask_mips_mt_irq
>  arch/mips/kernel/irq_cpu.c::97: unmask_mips_mt_irq
>  arch/powerpc/platforms/cell/axon_msi.c::312: mask_msi_irq
>  arch/powerpc/platforms/cell/axon_msi.c::313: unmask_msi_irq
>  arch/powerpc/platforms/cell/axon_msi.c::314: unmask_msi_irq
>  arch/powerpc/sysdev/cpm2_pic.c::205: cpm2_end_irq
>  arch/powerpc/sysdev/fsl_msi.c::47: mask_msi_irq
>  arch/powerpc/sysdev/fsl_msi.c::48: unmask_msi_irq
>  arch/powerpc/sysdev/mpic_pasemi_msi.c::60: mpic_end_irq
>  arch/powerpc/sysdev/mpic_pasemi_msi.c::61: mpic_set_irq_type
>  arch/powerpc/sysdev/mpic_pasemi_msi.c::62: mpic_set_affinity
>  arch/powerpc/sysdev/mpic_u3msi.c::42: mpic_end_irq
>  arch/powerpc/sysdev/mpic_u3msi.c::43: mpic_set_irq_type
>  arch/powerpc/sysdev/mpic_u3msi.c::44: mpic_set_affinity
>  arch/sparc/kernel/pci_msi.c::116: mask_msi_irq
>  arch/sparc/kernel/pci_msi.c::117: unmask_msi_irq
>  arch/sparc/kernel/pci_msi.c::118: unmask_msi_irq
>  arch/sparc/kernel/pci_msi.c::119: mask_msi_irq
>  arch/x86/kernel/apic/io_apic.c::3462: unmask_msi_irq
>  arch/x86/kernel/apic/io_apic.c::3463: mask_msi_irq
>  arch/x86/kernel/apic/io_apic.c::3473: unmask_msi_irq
>  arch/x86/kernel/apic/io_apic.c::3474: mask_msi_irq
>  arch/x86/kernel/apic/io_apic.c::3634: dmar_msi_unmask
>  arch/x86/kernel/apic/io_apic.c::3635: dmar_msi_mask
>  arch/x86/kernel/apic/io_apic.c::3689: hpet_msi_unmask
>  arch/x86/kernel/apic/io_apic.c::3690: hpet_msi_mask
>  arch/x86/kernel/apic/io_apic.c::3702: hpet_msi_unmask
>  arch/x86/kernel/apic/io_apic.c::3703: hpet_msi_mask
>  arch/x86/kernel/apic/io_apic.c::3788: mask_ht_irq
>  arch/x86/kernel/apic/io_apic.c::3789: unmask_ht_irq
>  drivers/parisc/dino.c::362: no_ack_irq
>  drivers/parisc/dino.c::363: no_end_irq
>  drivers/parisc/eisa.c::197: no_ack_irq
>  drivers/parisc/eisa.c::198: no_end_irq
>  drivers/parisc/gsc.c::157: no_ack_irq
>  drivers/parisc/gsc.c::158: no_end_irq
>  drivers/parisc/iosapic.c::738: cpu_ack_irq
>  drivers/parisc/superio.c::334: no_ack_irq
>  drivers/parisc/superio.c::335: no_end_irq
>
> initialization to local variable:
>  arch/arm/mach-pxa/irq.c::120: fn
>  arch/arm/mach-pxa/irq.c::151: fn
>  arch/arm/mach-pxa/pxa3xx.c::573: fn
>  arch/arm/plat-pxa/gpio.c::294: fn
>
> non-call use of a function:
>  arch/ia64/kernel/iosapic.c::417: mask_irq
>  arch/ia64/kernel/iosapic.c::418: unmask_irq
>  arch/ia64/kernel/iosapic.c::419: mask_irq
>  arch/ia64/kernel/iosapic.c::468: unmask_irq
>  arch/microblaze/kernel/intc.c::121: intc_enable_or_unmask
>  arch/microblaze/kernel/intc.c::122: intc_disable_or_mask
>  arch/microblaze/kernel/intc.c::123: intc_mask_ack
>  arch/microblaze/kernel/intc.c::124: intc_ack
>  arch/microblaze/kernel/intc.c::125: intc_end
>  arch/mips/dec/ioasic-irq.c::71: unmask_ioasic_irq
>  arch/mips/dec/ioasic-irq.c::73: mask_ioasic_irq
>  arch/mips/dec/ioasic-irq.c::75: ack_ioasic_irq
>  arch/mips/kernel/irq_cpu.c::64: unmask_mips_irq
>  arch/mips/kernel/irq_cpu.c::65: mask_mips_irq
>  arch/mn10300/kernel/irq.c::76: mn10300_cpupic_mask
>  arch/x86/kernel/i8259.c::397: legacy_pic_uint_noop
>  arch/xtensa/variants/s6000/gpio.c::169: mask
>  arch/xtensa/variants/s6000/gpio.c::192: mask
>  arch/xtensa/variants/s6000/gpio.c::195: mask
>  arch/xtensa/variants/s6000/gpio.c::198: mask
>  arch/xtensa/variants/s6000/gpio.c::201: mask
>  arch/xtensa/variants/s6000/gpio.c::204: mask
>  arch/xtensa/variants/s6000/gpio.c::209: mask
>  arch/xtensa/variants/s6000/gpio.c::216: mask
>  arch/xtensa/variants/s6000/gpio.c::219: mask
>  arch/xtensa/variants/s6000/gpio.c::221: mask
>  arch/xtensa/variants/s6000/gpio.c::224: mask
>  include/linux/kernel.h::41: mask
>  kernel/irq/chip.c::345: default_disable
>
> non-static function:
>  arch/alpha/kernel/irq_i8259.c::88: i8259a_startup_irq
>  arch/alpha/kernel/irq_i8259.c::89: i8259a_disable_irq
>  arch/alpha/kernel/irq_i8259.c::90: i8259a_enable_irq
>  arch/alpha/kernel/irq_i8259.c::91: i8259a_disable_irq
>  arch/alpha/kernel/irq_i8259.c::92: i8259a_mask_and_ack_irq
>  arch/alpha/kernel/irq_i8259.c::93: i8259a_end_irq
>  arch/arm/mach-msm/board-sapphire-gpio.c::264: sapphire_gpio_irq_set_wake
>  arch/arm/mach-msm/board-trout-gpio.c::248: trout_gpio_irq_set_wake
>  arch/arm/plat-s3c24xx/irq.c::240: s3c_irqext_type
>  arch/arm/plat-s3c24xx/irq.c::250: s3c_irqext_type
>  arch/blackfin/mach-common/ints-priority.c::274: bfin_internal_set_wake
>  arch/blackfin/mach-common/ints-priority.c::937: bfin_gpio_set_wake
>  arch/cris/arch-v32/kernel/irq.c::346: set_affinity_crisv32_irq
>  arch/mips/jazz/irq.c::49: disable_r4030_irq
>  arch/mips/jazz/irq.c::50: disable_r4030_irq
>  arch/mips/jazz/irq.c::51: disable_r4030_irq
>  arch/mips/lasat/interrupt.c::49: disable_lasat_irq
>  arch/mips/lasat/interrupt.c::50: disable_lasat_irq
>  arch/mips/lasat/interrupt.c::51: disable_lasat_irq
>  arch/mips/lasat/interrupt.c::52: enable_lasat_irq
>  arch/mips/sni/pcimt.c::218: disable_pcimt_irq
>  arch/mips/sni/pcimt.c::219: disable_pcimt_irq
>  arch/mips/sni/pcimt.c::220: disable_pcimt_irq
>  arch/mips/sni/pcit.c::180: disable_pcit_irq
>  arch/mips/sni/pcit.c::181: disable_pcit_irq
>  arch/mips/sni/pcit.c::182: disable_pcit_irq
>  arch/mips/sni/pcit.c::184: end_pcit_irq
>  arch/mips/sni/rm200.c::289: sni_rm200_mask_and_ack_8259A
>  arch/mips/sni/rm200.c::453: disable_rm200_irq
>  arch/mips/sni/rm200.c::454: disable_rm200_irq
>  arch/mips/sni/rm200.c::455: disable_rm200_irq
>  arch/mips/sni/rm200.c::457: end_rm200_irq
>  arch/powerpc/sysdev/mpic.c::907: mpic_mask_irq
>  arch/powerpc/sysdev/mpic.c::908: mpic_unmask_irq
>  arch/powerpc/sysdev/mpic.c::909: mpic_end_irq
>  arch/powerpc/sysdev/mpic.c::910: mpic_set_irq_type
>  arch/powerpc/sysdev/mpic.c::925: mpic_mask_irq
>  arch/powerpc/sysdev/mpic.c::928: mpic_set_irq_type
>  arch/sh/boards/mach-cayman/irq.c::100: disable_cayman_irq
>
> non-test or call reference to field:
>  kernel/irq/manage.c::432: set_type
>
> non-updated function:
>  arch/arm/mach-s3c2410/bast-irq.c::109: bast_pc104_maskack
>  arch/m68knommu/platform/coldfire/intc.c::129: intc_irq_unmask
>  arch/powerpc/sysdev/cpm2_pic.c::116: cpm2_end_irq
