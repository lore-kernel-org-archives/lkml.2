Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2DMCC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 22:02:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37096 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2DMCC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 22:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120413014505.GC30438@windriver.com>
References: <20120413014505.GC30438@windriver.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 12 Apr 2012 22:02:24 -0400
X-Google-Sender-Auth: _iK4qG_e7zWguTF7Zsj6k_pMpMs
Message-ID: <CAP=VYLpq2BUcNEBKJ9bruZb5FAK2fHFPTdUC7=dnJgRU1MMFuQ@mail.gmail.com>
Subject: Re: linux-next: triage for April 12, 2012
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 9:45 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> This is kind of a "two days in one" report.  Remember that this
> report lags sfr's treegen by ~24h so that kisskb builds can run.
>
> The i386 allmodconfig lost its rc5t583-regulator license typo fail
> but picked up two more new fails (one still via rc5t583-regulator).

I forgot to mention that the m86k builds lost their android/persistent_ram.c
issue, but got fetched up on wiznet (reported by Geert and fix already
applied by DaveM) --  https://lkml.org/lkml/2012/4/12/369

P.

>
> ----------------------
>
> New breakage since last report:
>        i386:allmodconfig
>                ("rc5t583_ext_power_req_config" undefined)
>                ("__udivdi3" [ethernet/mellanox/mlx4/mlx4_en.ko] undefined)
>        ARM:u8500_defconfig
>                (implicit declaration of function 'regulator_disable')
>        powerpc:mpc85xx_defconfig
>                (spi-fsl-lib.c:68 dereferencing pointer to incomplete type)
>
> Randconfig fails that may or may not be new (by their very nature):
>        powerpc: iommu.c: implicit decl of function 'pci_dev_to_eeh_dev'
>                ( http://kisskb.ellerman.id.au/kisskb/buildresult/6095808/ )
>
> Builds that are fixed since last report:
>        ARM:eseries_pxa_defconfig,em_x270_defconfig,imx_v4_v5_defconfig
>                (sound/soc/codecs/wm9712.c: error: 'runtime' undeclared)
>        ARM/MIPS:magician_defconfig,omap1_defconfig,ip27_defconfig,s3c2410_defconfig
>                (regmap.c: too few arg to 'regmap_debugfs_init')
>        s390/sparc:allmodconfig,allyesconfig
>                (wiznet Kconfig fallout)
>        i386:allmodconfig
>                (GPL-incompatible module rc5t583-regulator.ko uses GPL-only symbol)
>
> Note: The randconfig fails are only listed once and not tracked
> in the below listing.
>
> I'm also not tracking the kallsyms extra pass stuff on ARM on
> a per board basis anymore.  It has nothing to do with the board.
> Why? See:  http://marc.info/?l=linux-next&m=133267456809502
>
>            ------------------------------------------------
>
> Latest results at:
>        http://kisskb.ellerman.id.au/kisskb/branch/9/
>
> Failures as of April 12th, 2012:
> ===============================
>
> AM33:asb2303_defconfig,asb2364_defconfig
>        when:   Mar 15
>        why:    cc1: error: unrecognized command line option '-mmem-funcs'
>        status: Possible fix from TonyB sent for review.
>        fix:    http://marc.info/?l=linux-kernel&m=133185020313818&w=2
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
> ----------------
>
> ARM:u8500_defconfig
>        when:   Apr 11
>        why:    ste_dma40.c: implicit declaration of function 'regulator_disable'
>        status: reported
>        fix:
>        ref:    http://marc.info/?l=linux-next&m=133428028418892&w=2
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6091624/
>
> ARM:netx_defconfig,pnx4008_defconfig
>        when:   Mar 14
>        why:    net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
>        ref:    https://lkml.org/lkml/2012/3/13/670
>
> ARM:ixp4xx_defconfig
>        when:   Oct 26
>        why:    gpio.h: implicit declaration of function '__gpio_get_value'
>        status: fixed (Imre Kaloz) - but possibly needs rework?
>        fix:    https://lkml.org/lkml/2012/2/8/288
>        ref:    https://lkml.org/lkml/2012/2/8/287
>
> ARM:raumfeld_defconfig
>        when:   Nov 23
>        why:    eeti_ts.c: implicit declaration of function 'irq_to_gpio'
>        status: perhaps broken since 2010?  See ref below.
>        fix:
>        ref:    http://www.gossamer-threads.com/lists/linux/kernel/1291618?do=post_view_threaded#1291618
>
> ARM:arm-allnoconfig
>        when:   forever
>        why:    not supported
>        status: nothing pending, but patches accepted
>        fix:    n/a
>        ref:    https://lkml.org/lkml/2009/4/30/105
>        ref:    http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081218.html
> ----------------
>
> AVR32:allnoconfig
>        when:   May 26 2010, 20:49
>        why:    at32_map_usart: undefined reference to `atmel_default_console_device'
>        status:
>        fix:
>        ref:
> ---------------
>
> bfin: 50% of builds
>        when:   Mar 31
>        why:    "Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
>        status: unknown, binutils issue?
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/
> ---------------
>
> cris:allyesconfig,allmodconfig
>        when:   Apr 3
>        why:    too many to list here
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
> ----------------
>
> frv:defconfig
>        when:   Mar 15
>        why:    undefined reference to `pci_cardbus_resource_alignment'
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6030067/
> ----------------
>
> i386:allmodconfig
>        when:   Apr 11
>        why:    "rc5t583_ext_power_req_config" [drivers/regulator/rc5t583-regulator.ko] undefined!
>        why:    "__udivdi3" [drivers/net/ethernet/mellanox/mlx4/mlx4_en.ko] undefined!
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6091475/
> ----------------
>
> h8300:defconfig
>        when:   Mar 15
>        why:    time.c: implicit declaration of function 'get_irq_regs'
>        why:    also seems gcc suffers an ICE
>        status: ICE bug lodged with gcc folks (TonyB)
>        fix:
>        ref:    http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
> ----------------
>
> m32r:m32700ut.smp_defconfig
>        when:   Mar 15
>        why:    No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
> ----------------
>
> m68k:allmodconfig
>        when:   Mar 16
>        why:    persistent_ram.c: implicit declaration of 'memblock_reserve'
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5884324/
>        ref:    http://www.spinics.net/lists/linux-next/msg19343.html
> ----------------
>
> mips:allmodconfig
>        when:
>        why:    driver_pci_host.c: implicit declaration of function 'pcibios_enable_device'
>        status: one of many fixes mips needs...
>        fix:    http://marc.info/?l=linux-wireless&m=133272031621916&w=2
>        ref:    http://patchwork.ozlabs.org/patch/148614/
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5807000/
> ----------------
>
> parisc:allmodconfig
>        when:
>        why:    include/linux/log2.h: implicit declaration of function 'fls'
>        status: reported by PaulG, WIP by David Howells
>        fix:
>        ref:    https://lkml.org/lkml/2012/2/29/409
>        ref:    https://lkml.org/lkml/2012/3/6/228
>
> parisc64:a500_defconfig
>        when:
>        why:    include/linux/log2.h: implicit declaration of function 'fls'
>        status: reported by PaulG, WIP by David Howells
>        fix:
>        ref:    https://lkml.org/lkml/2012/2/29/409
>        ref:    https://lkml.org/lkml/2012/3/6/228
> ------------------
>
> powerpc:allyesconfig
>        when:   May 18 2009, 22:11
>        why:    fat ass kernel with everything simply won't link
>        status: need to fix build config to ignore the final link
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5806793/
> ------------------
>
> um:um-defconfig
>        when:   Sep 16 2010, 01:28
>        why:    os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
>        status: clearly broken forever, so does anyone care?
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/target/2979/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
