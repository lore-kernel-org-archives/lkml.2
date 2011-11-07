Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1KGXdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:33:41 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:54307 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008Ab1KGXdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:33:39 -0500
Date: Mon, 7 Nov 2011 23:33:30 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
Message-ID: <20111107233330.GA26705@linux-mips.org>
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
 <4E69FEC9.2080204@suse.cz>
 <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
 <20111101232233.GA32441@sepie.suse.cz>
 <20111107204448.GA9949@linux-mips.org>
 <20111107211900.GB6264@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111107211900.GB6264@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 10:19:00PM +0100, Michal Marek wrote:

> Wild guess - does this patch help?
> 
> 
> diff --git a/Kbuild b/Kbuild
> index 4caab4f..77c191a 100644
> --- a/Kbuild
> +++ b/Kbuild
> @@ -94,7 +94,7 @@ targets += missing-syscalls
>  quiet_cmd_syscalls = CALL    $<
>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
>  
> -missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
> +missing-syscalls: scripts/checksyscalls.sh $(offsets-file) $(bounds-file) FORCE
>  	$(call cmd,syscalls)
>  
>  # Keep these two files during make clean

No, it didn't.

> If not, please attach logs of make V=1 with clean Linus' tree and with
> 5f7efb4c6da9f90cb306923ced2a6494d065a595 reverted.

$ git checkout 31555213f03bca37d2c02e10946296052f4ecfcd
$ git revert 5f7efb4c6da9f90cb306923ced2a6494d065a595
$ make ARCH=mips ip27_defconfig
$ make ARCH=mips V=1 2>&1 | tee log

make -f /home/ralf/src/linux/linux-mips/Makefile silentoldconfig
make -f scripts/Makefile.build obj=scripts/basic
rm -f .tmp_quiet_recordmcount
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig silentoldconfig
mkdir -p include/generated
scripts/kconfig/conf --silentoldconfig Kconfig
warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI && RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
rm -f include/config/kernel.release
echo "3.1.0$(/bin/sh /home/ralf/src/linux/linux-mips/scripts/setlocalversion /home/ralf/src/linux/linux-mips)" > include/config/kernel.release
make -f /home/ralf/src/linux/linux-mips/scripts/Makefile.asm-generic \
            obj=arch/mips/include/generated/asm
set -e; : '  CHK     include/linux/version.h'; mkdir -p include/linux/; 	(echo \#define LINUX_VERSION_CODE 196864; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /home/ralf/src/linux/linux-mips/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else : '  UPD     include/linux/version.h'; mv -f include/linux/version.h.tmp include/linux/version.h; fi
set -e; : '  CHK     include/generated/utsrelease.h'; mkdir -p include/generated/; 	if [ `echo -n "3.1.0-10325-g3155521-dirty" | wc -c ` -gt 64 ]; then echo '"3.1.0-10325-g3155521-dirty" exceeds 64 characters' >&2; exit 1; fi; (echo \#define UTS_RELEASE \"3.1.0-10325-g3155521-dirty\";) < include/config/kernel.release > include/generated/utsrelease.h.tmp; if [ -r include/generated/utsrelease.h ] && cmp -s include/generated/utsrelease.h include/generated/utsrelease.h.tmp; then rm -f include/generated/utsrelease.h.tmp; else : '  UPD     include/generated/utsrelease.h'; mv -f include/generated/utsrelease.h.tmp include/generated/utsrelease.h; fi
mkdir -p .tmp_versions ; rm -f .tmp_versions/*
make -f scripts/Makefile.build obj=scripts/basic
(cat /dev/null; ) > scripts/basic/modules.order
rm -f .tmp_quiet_recordmcount
  Checking missing-syscalls for N32
make -f scripts/Makefile.build obj=. missing-syscalls ccflags-y="-mabi=n32"
  /bin/sh scripts/checksyscalls.sh mips64-linux-gcc -Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem /usr/lib64/gcc/mips64-linux/4.6.0/include -I/home/ralf/src/linux/linux-mips/arch/mips/include -Iarch/mips/include/generated -Iinclude  -include /home/ralf/src/linux/linux-mips/include/linux/kconfig.h -D__KERNEL__ -D"VMLINUX_LOAD_ADDRESS=0xa80000000001c000" -D"DATAOFFSET=0" -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -mno-check-zero-division -mabi=64 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -march=r10000 -Wa,--trap -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-ip27 -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-generic -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO -mabi=n32    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)"  -D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
<stdin>:1562:2: warning: #warning syscall process_vm_readv not implemented [-Wcpp]
<stdin>:1566:2: warning: #warning syscall process_vm_writev not implemented [-Wcpp]
  Checking missing-syscalls for O32
make -f scripts/Makefile.build obj=. missing-syscalls ccflags-y="-mabi=32"
  /bin/sh scripts/checksyscalls.sh mips64-linux-gcc -Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem /usr/lib64/gcc/mips64-linux/4.6.0/include -I/home/ralf/src/linux/linux-mips/arch/mips/include -Iarch/mips/include/generated -Iinclude  -include /home/ralf/src/linux/linux-mips/include/linux/kconfig.h -D__KERNEL__ -D"VMLINUX_LOAD_ADDRESS=0xa80000000001c000" -D"DATAOFFSET=0" -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -mno-check-zero-division -mabi=64 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -march=r10000 -Wa,--trap -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-ip27 -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-generic -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO -mabi=32    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)"  -D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
<stdin>:1562:2: warning: #warning syscall process_vm_readv not implemented [-Wcpp]
<stdin>:1566:2: warning: #warning syscall process_vm_writev not implemented [-Wcpp]
make -f scripts/Makefile.build obj=.
(cat /dev/null; ) > modules.order
mkdir -p kernel/
  mips64-linux-gcc -Wp,-MD,kernel/.bounds.s.d  -nostdinc -isystem /usr/lib64/gcc/mips64-linux/4.6.0/include -I/home/ralf/src/linux/linux-mips/arch/mips/include -Iarch/mips/include/generated -Iinclude  -include /home/ralf/src/linux/linux-mips/include/linux/kconfig.h -D__KERNEL__ -D"VMLINUX_LOAD_ADDRESS=0xa80000000001c000" -D"DATAOFFSET=0" -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -mno-check-zero-division -mabi=64 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -march=r10000 -Wa,--trap -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-ip27 -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-generic -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(bounds)"  -D"KBUILD_MODNAME=KBUILD_STR(bounds)" -fverbose-asm -S -o kernel/bounds.s kernel/bounds.c
mkdir -p include/generated/
  	(set -e; echo "#ifndef __LINUX_BOUNDS_H__"; echo "#define __LINUX_BOUNDS_H__"; echo "/*"; echo " * DO NOT MODIFY."; echo " *"; echo " * This file was generated by Kbuild"; echo " *"; echo " */"; echo ""; sed -ne 	"/^->/{s:->#\(.*\):/* \1 */:; s:^->\([^ ]*\) [\$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; s:^->\([^ ]*\) [\$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}" kernel/bounds.s; echo ""; echo "#endif" ) > include/generated/bounds.h
mkdir -p arch/mips/kernel/
  mips64-linux-gcc -Wp,-MD,arch/mips/kernel/.asm-offsets.s.d  -nostdinc -isystem /usr/lib64/gcc/mips64-linux/4.6.0/include -I/home/ralf/src/linux/linux-mips/arch/mips/include -Iarch/mips/include/generated -Iinclude  -include /home/ralf/src/linux/linux-mips/include/linux/kconfig.h -D__KERNEL__ -D"VMLINUX_LOAD_ADDRESS=0xa80000000001c000" -D"DATAOFFSET=0" -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -mno-check-zero-division -mabi=64 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -march=r10000 -Wa,--trap -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-ip27 -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-generic -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"  -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o arch/mips/kernel/asm-offsets.s arch/mips/kernel/asm-offsets.c
  	(set -e; echo "#ifndef __ASM_OFFSETS_H__"; echo "#define __ASM_OFFSETS_H__"; echo "/*"; echo " * DO NOT MODIFY."; echo " *"; echo " * This file was generated by Kbuild"; echo " *"; echo " */"; echo ""; sed -ne 	"/^->/{s:->#\(.*\):/* \1 */:; s:^->\([^ ]*\) [\$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; s:^->\([^ ]*\) [\$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}" arch/mips/kernel/asm-offsets.s; echo ""; echo "#endif" ) > include/generated/asm-offsets.h
make -f scripts/Makefile.build obj=. missing-syscalls
  /bin/sh scripts/checksyscalls.sh mips64-linux-gcc -Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem /usr/lib64/gcc/mips64-linux/4.6.0/include -I/home/ralf/src/linux/linux-mips/arch/mips/include -Iarch/mips/include/generated -Iinclude  -include /home/ralf/src/linux/linux-mips/include/linux/kconfig.h -D__KERNEL__ -D"VMLINUX_LOAD_ADDRESS=0xa80000000001c000" -D"DATAOFFSET=0" -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -mno-check-zero-division -mabi=64 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -march=r10000 -Wa,--trap -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-ip27 -I/home/ralf/src/linux/linux-mips/arch/mips/include/asm/mach-generic -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)"  -D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
<stdin>:1562:2: warning: #warning syscall process_vm_readv not implemented [-Wcpp]
<stdin>:1566:2: warning: #warning syscall process_vm_writev not implemented [-Wcpp]
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/mod

Thanks,

  Ralf
