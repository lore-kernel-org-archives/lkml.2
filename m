Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0KTHzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 02:55:55 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:55780 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0KTHzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 02:55:51 -0500
X-Greylist: delayed 2102 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 02:55:51 EST
From: "Guan" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Sat, 20 Nov 2010 15:20:19 +0800
Message-ID: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuIg0VAYaA6UZEKT8uYCl4GZtflyA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please download second patches for review:
 
http://mprc.pku.edu.cn/~guanxuetao/linux/patch-2.6.37-rc2-uc32-gxt2-arch.bz2
  (above patch for arch/unicore32 directory, 149KB)
 
http://mprc.pku.edu.cn/~guanxuetao/linux/patch-2.6.37-rc2-uc32-gxt2-drivers.
bz2
  (above patch for drivers/staging/puv3 directory, which including some
necessary drivers, 31KB)
 
http://mprc.pku.edu.cn/~guanxuetao/linux/patch-2.6.37-rc2-uc32-gxt2-rest.bz2
  (above patch for rest patch code, for modifying the file not in
arch/unicore32 and drivers/staging/puv3, 2KB)

Replying Arnd's:
> It would be good if you could make a tool chain available, ideally both
> a patch against gcc and pre-built binaries for an x86-unicore cross
> compiler. This is not strictly required, but it helps to get people
> to do build tests on your code.
[Guan] please download x86-unicore cross toolchain from:
	http://mprc.pku.edu.cn/~guanxuetao/linux/uc4-1.0.5-hard.tgz 
	(about 100MB)
	It should be un-tar to /usr/unicore/gnu-toolchain-unicore directory.

> Further, you should find a way to publish git trees with your code, since
> a patch on a web site is less than ideal for transporting code changes,
> especially once the code gets merged into linux-next and mainline
afterwards.
> If your university or company has problems setting up an official git
> server, you can ask for an account on kernel.org, see
> http://www.kernel.org/faq/#account
> 
[Guan] I have requested for kernel.org account, but no response now.

> Detailed comments below.
> 
> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/boot/compressed/decompress.c
> linux-2.6.37.y/arch/unicore32/boot/compressed/decompress.c
> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/boot/compressed/misc.c
> linux-2.6.37.y/arch/unicore32/boot/compressed/misc.c
> 
> These two files look very generic. It may be a good time to now move
> them into the global lib/ directory and make them usable by all
> architectures that do not require special fixups in the decompress
> code.
[Guan] I have modified these files, and make it more generic.

> > +MKIMAGE         := $(srctree)/scripts/mkuboot.sh
> 
> Do you have u-boot support as well?
[Guan] Yes, we use u-boot as bootloader.

> > +CONFIG_CMDLINE_FROM_U_BOOT=y
> > +CONFIG_CMDLINE="mem=512M ignore_loglevel
> video=unifb:1024x600-16@75 root=/dev/nfs rw
> nfsroot=/home/nfs/uc3,rsize=1024,wsize=1024
> ip=192.168.10.83:192.168.10.82:192.168.10.1:255.255.255.0::eth0:off"
> 
> You should never need to pass the memory size in the command line.
> Please ensure that the boot loader always passes the memory size
> using your boot protocol (ideally in a device tree).
> 
[Guan] CMDLINE will only be used when no bootloader params.
  And u-boot params have another cmdline to replace this one.

> Similarly, the frame buffer size should ideally be autodetected
> using hardware or the boot protocol, though that can be harder.
[Guan] I have to remain this method at present.


> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/configs/nb0916_defconfig
> linux-2.6.37.y/arch/unicore32/configs/nb0916_defconfig
> > --- linux-2.6.37-rc1/arch/unicore32/configs/nb0916_defconfig
1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/configs/nb0916_defconfig	2010-11-08
> 10:14:07.110692045 +0800
> 
> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/configs/smw0919_defconfig
> linux-2.6.37.y/arch/unicore32/configs/smw0919_defconfig
> > --- linux-2.6.37-rc1/arch/unicore32/configs/smw0919_defconfig
> 	1970-01-01 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/configs/smw0919_defconfig
> 	2010-11-08 10:14:07.110692045 +0800
> 
> The files look mostly identical. If there is no fundamental difference
> between them, I would recommend providing only a single defconfig file
> that works on all the machines.
[Guan] nb0916 is for netbook and desktop, and CONFIG_MODULES must be
enabled.
  Smw0919 is for safety embedded devices, only necessary devices/drivers are
integrated.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h
> linux-2.6.37.y/arch/unicore32/include/asm/dma.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/dma.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/dma.h	2010-11-11
> 09:55:29.517572760 +0800
> > @@ -0,0 +1,34 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/dma.h
> 
> Just use the asm-generic file.
[Guan] when I set MAX_DMA_ADDRESS to PAGE_OFFSET, some pci drivers have
problem.
  I will check it later.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/fixmap.h
> linux-2.6.37.y/arch/unicore32/include/asm/fixmap.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/fixmap.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/fixmap.h	2010-11-08
> 15:36:42.574862020 +0800
> > @@ -0,0 +1,51 @@
> > +/*
> > + * Nothing too fancy for now.
> > + *
> > + * On UniCore we already have well known fixed virtual addresses
imposed
> by
> > + * the architecture such as the vector page which is located at
0xffff0000,
> 
> The comment is copied from ARM, but is it really true on unicore?
> 
[Guan] Yes.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h
> linux-2.6.37.y/arch/unicore32/include/asm/highmem.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/highmem.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/highmem.h	2010-11-08
> 15:53:09.077836027 +0800
> > @@ -0,0 +1,53 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/highmem.h
> 
> What is the maximum amount of memory you support on the 32 bit machines?
> We're removing all the optimizations for highmem from the kernel now, so
> I would recommend not to support this in new architectures if you can
> avoid it.
[Guan] we need to support 2GB memory.
> 
> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/io.h
> linux-2.6.37.y/arch/unicore32/include/asm/io.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/io.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/io.h	2010-11-11
> 10:23:14.258566201 +0800
> > @@ -0,0 +1,275 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/io.h
> 
> This also looks similar to the asm-generic version. Can you use that, or
> possibly change it enough so you can?
[Guan] I recommend splitting asm-generic/io.h into io.h and ioremap.h

> > +/*
> > + * Use this value to indicate lack of interrupt
> > + * capability
> > + */
> > +#ifndef NO_IRQ
> > +#define NO_IRQ	((unsigned int)(-1))
> > +#endif
> 
> This should not be required at all any more.
> 
[Guan] amba bus driver need NO_IRQ

> > +#####
> > +# Auto Generate the files that only include the corresponding
asm-generic
> file
> > +#   6 files in 27-uc: errno.h fcntl.h ioctl.h poll.h resource.h
siginfo.h
> > +
> > +define cmd_asmgeneric
> > +	(set -e; \
> > +	 echo '#include <asm-generic/$(notdir $@)>' )	> $@
> > +endef
> 
> Nice trick. I'd love to have something like this in the common code so
> we can do the same for all architectures.
> 
> Does this work with external object directories, i.e. building with
> make O=objdir, and with make headers_install?
> 
[Guan] For UniCore, more than forty headers are auto generated.
 However, if all non-exist headers are auto-generated, it would make a
terrible mess.
 So, it should depend on archprepare rule in arch/xxx/Makefile, but not in
Kbuild.
 I think the arch maintainers should determine which files are needed.
 Also, make headers_install works well.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h
> linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/pci.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/pci.h	2010-11-08
> 17:46:49.475569661 +0800
> > @@ -0,0 +1,65 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/mach/pci.h
> > +
> > +struct hw_pci {
> > +#ifdef CONFIG_PCI_DOMAINS
> > +	int		domain;
> > +#endif
> > +	struct list_head buses;
> > +	int		nr_controllers;
> > +	int		(*setup)(int nr, struct pci_sys_data *);
> > +	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
> > +	void		(*preinit)(void);
> > +	void		(*postinit)(void);
> > +	u8		(*swizzle)(struct pci_dev *dev, u8 *pin);
> > +	int		(*map_irq)(struct pci_dev *dev, u8 slot, u8 pin);
> > +};
> > +
> > +/*
> > + * Per-controller structure
> > + */
> > +struct pci_sys_data {
> > +#ifdef CONFIG_PCI_DOMAINS
> > +	int		domain;
> > +#endif
> > +	struct list_head node;
> > +	int		busnr;		/* primary bus number		  */
> > +	u64		mem_offset;	/* bus->cpu memory mapping offset */
> > +	unsigned long	io_offset;	/* bus->cpu IO mapping offset	  */
> > +	struct pci_bus	*bus;		/* PCI bus			  */
> > +	struct resource *resource[3];	/* Primary PCI bus resources	  */
> > +					/* Bridge swizzling		  */
> > +	u8		(*swizzle)(struct pci_dev *, u8 *);
> > +					/* IRQ mapping			  */
> > +	int		(*map_irq)(struct pci_dev *, u8, u8);
> > +	struct hw_pci	*hw;
> > +	void		*private_data;	/* platform controller private data
*/
> > +};
> 
> These are two separate abstractions for multiple PCI controllers,
> but your code does not even contain one implementation.
> 
> I can only assume that you actually have a PCI implementation, but
> if you do not have more than one, you are better off implementing just
> the one you have instead of extra wrappers.
[Guan] we do have pci bus and pci driver. I have to implement these
interface for pci compatibility.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h
> linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/mach/time.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/mach/time.h	2010-11-08
> 17:48:06.111456784 +0800
> > @@ -0,0 +1,52 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/mach/time.h
> 
> Can be removed when you get rid of the machine_desc abstraction.
[Guan] sys_timer can't be removed, which is used for device register.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h
> linux-2.6.37.y/arch/unicore32/include/asm/memblock.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/memblock.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/memblock.h	2010-11-10
> 18:59:14.326006751 +0800
> > @@ -0,0 +1,22 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/memblock.h
> 
> This too.
[Guan] we use memblock as infrastructure, and perhaps it's not good.

> Also, do you actually support both MMU and NOMMU modes?
[Guan] Only support MMU mode.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/swab.h
> linux-2.6.37.y/arch/unicore32/include/asm/swab.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/swab.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/swab.h	2010-11-09
> 09:28:21.005577540 +0800
> > @@ -0,0 +1,51 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/swab.h
> > + *
> > + * Code specific to PKUnity SoC and UniCore ISA
> > + *
> > + * Copyright (C) 2001-2008 GUAN Xue-tao
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * In little endian mode, the data bus is connected such
> > + * that byte accesses appear as:
> > + *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
> > + * and word accesses (data or instruction) appear as:
> > + *  d0...d31
> > + */
> > +#ifndef __UNICORE_SWAB_H__
> > +#define __UNICORE_SWAB_H__
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> > +
> > +#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> > +#  define __SWAB_64_THRU_32__
> > +#endif
> > +
> > +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
> 
> Can't you use the __builtin_bswap32/__builtin_bswap64 provided by gcc?
[Guan] __bswapsi2 is in libgcc, which is needed by __builtin_bswap32.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h
> linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/uaccess.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/uaccess.h	2010-11-09
> 11:33:30.209566466 +0800
> > @@ -0,0 +1,408 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/uaccess.h
> 
> Please have another look at the asm-generic version of this file.
> With the current version it may be useful to base on that.
[Guan] __copy_from_user and __copy_to_user is too expensive for 1/2/4 words.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h
> linux-2.6.37.y/arch/unicore32/include/asm/unistd.h
> > --- linux-2.6.37-rc1/arch/unicore32/include/asm/unistd.h	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/include/asm/unistd.h	2010-11-11
> 10:47:36.743710466 +0800
> 
> Please use the cleaned-up asm-generic version as arch/tile does now.
> You add a lot of overhead otherwise.
[Guan] we use __NR_* as the immediate number in soft-interrupt instruction.
     And if the syscall number changed, all software and toolchain need
re-compiled.

> > diff -uprN -X linux-2.6.37-rc1/Documentation/dontdiff
> linux-2.6.37-rc1/arch/unicore32/Kconfig
linux-2.6.37.y/arch/unicore32/Kconfig
> > --- linux-2.6.37-rc1/arch/unicore32/Kconfig	1970-01-01
08:00:00.000000000
> +0800
> > +++ linux-2.6.37.y/arch/unicore32/Kconfig	2010-11-11
10:40:02.001225028
> +0800
> > @@ -0,0 +1,337 @@
> > +	config ARCH_PUV3
> > +	bool "PKUnity v3 (SuperK)"
> > +	select CPU_UCV2
> > +	select PKUNITY_AMBA
> > +	select ZONE_DMA
> > +	select EMBEDDED
> > +	select GENERIC_CLOCKEVENTS
> > +	select HAVE_CLK
> > +	select ARCH_USES_GETTIMEOFFSET
> > +	select ARCH_REQUIRE_GPIOLIB
> > +	select ARCH_HAS_CPUFREQ
> 
> You might not want to select ZONE_DMA and ARCH_USES_GETTIMEOFFSET,
> since you are generally better off without them.
[Guan] We need ZONE_DMA for only 128M low memory could be used for DMA.

> That's all for now, let's discuss my comments first and then I'll
> start commenting on the next parts.
[Guan] Thank you very much!

Guan Xuetao


