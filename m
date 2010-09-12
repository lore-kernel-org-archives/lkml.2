Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0ILLMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:12:38 -0400
Received: from tuxonice.net ([74.207.252.127]:37445 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0ILLMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:12:37 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C8CB5A1.9040500@tuxonice.net>
Date: Sun, 12 Sep 2010 21:12:33 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: 2.6.36-rc3 - Unable to build: "Error: input truncated"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I'm unable to compile the latest kernel and git bisect isn't helping:

git bisect start
# bad: [0f0806ee005ca835d97dfe59a0d3b7856e9f7ca4] Merge branch 'stable' 
into combined
git bisect bad 0f0806ee005ca835d97dfe59a0d3b7856e9f7ca4
# good: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect good 9fe6206f400646a2322096b56c59891d530e8d51
# bad: [73045c47b6facbdf4656e6763c8cb469de4337e2] memcg: remove mem from 
arg of charge_common
git bisect bad 73045c47b6facbdf4656e6763c8cb469de4337e2
# bad: [89a6c8cb9e6e11b6e3671dce7e037789b8f7cf62] Merge branch 
'for_linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb
git bisect bad 89a6c8cb9e6e11b6e3671dce7e037789b8f7cf62
# good: [3ff1c25927e3af61c6bf0e4ed959504058ae4565] phy/marvell: add 
88ec048 support
git bisect good 3ff1c25927e3af61c6bf0e4ed959504058ae4565
# bad: [5e83f6fbdb020b70c0e413312801424d13c58d68] Merge branch 
'kvm-updates/2.6.36' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect bad 5e83f6fbdb020b70c0e413312801424d13c58d68
# bad: [7e6880951da86928c7f6cecf26dcb8e8d9f826da] Merge branch 
'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
git bisect bad 7e6880951da86928c7f6cecf26dcb8e8d9f826da
# bad: [7b70c4275f28702b76b273c8534c38f8313812e9] Merge branch 
'devel-stable' into devel
git bisect bad 7b70c4275f28702b76b273c8534c38f8313812e9
# good: [79d3c2c2395a89a70d25f0c77c11afc87efab89b] mx2_camera: fix type 
of dma buffer virtual address pointer
git bisect good 79d3c2c2395a89a70d25f0c77c11afc87efab89b
# bad: [b31fc7af78e17b0203e1cd5a195c590e8adeae0d] Merge branches 'at91', 
'ep93xx', 'kexec', 'iop', 'lmb', 'nomadik', 'nuc', 'pl', 'spear' and 
'versatile' into devel
git bisect bad b31fc7af78e17b0203e1cd5a195c590e8adeae0d
# bad: [39ae702cd3b8b9d30693b73ad1a3d74c799b5b1a] ARM: 6267/1: mop500: 
add AB8500 interrupt support
git bisect bad 39ae702cd3b8b9d30693b73ad1a3d74c799b5b1a
# bad: [33f45ea91706f8fdde04bd6c2245f679403ec63f] ARM: 6156/1: 
nomadik-gpio: switch to core_initcall
git bisect bad 33f45ea91706f8fdde04bd6c2245f679403ec63f
# bad: [5b327edf03c037ea6dc49a98a2b7f7186298ad1e] ARM: 6148/1: 
nomadik-gpio: add function to configure pullup/pulldown
git bisect bad 5b327edf03c037ea6dc49a98a2b7f7186298ad1e
# bad: [6647c6c0b62ae14ca994c5776ddb084820bea808] ARM: 6147/1: 
nomadik-gpio: set val in ->direction_output()
git bisect bad 6647c6c0b62ae14ca994c5776ddb084820bea808
# bad: [5c0c1f08abf094273f40a6d6fd4519fcacc6c58d] ARM: 6150/1: gic: 
implement set_type
git bisect bad 5c0c1f08abf094273f40a6d6fd4519fcacc6c58d

Here's what I get:

nigel@nigel-laptop:/usr/src/tuxonice-head$ rm -f scripts/mod/empty.o
nigel@nigel-laptop:/usr/src/tuxonice-head$ rm -f scripts/mod/elfconfig.h
nigel@nigel-laptop:/usr/src/tuxonice-head$ make V=1
rm -f include/config/kernel.release
echo "2.6.36-rc3$(/bin/bash 
/usr/src/tuxonice-head/scripts/setlocalversion /usr/src/tuxonice-head)" 
 > include/config/kernel.release
set -e; : '  CHK     include/linux/version.h'; mkdir -p 
include/linux/; 	(echo \#define LINUX_VERSION_CODE 132644; echo '#define 
KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < 
/usr/src/tuxonice-head/Makefile > include/linux/version.h.tmp; if [ -r 
include/linux/version.h ] && cmp -s include/linux/version.h 
include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; 
else : '  UPD     include/linux/version.h'; mv -f 
include/linux/version.h.tmp include/linux/version.h; fi
set -e; : '  CHK     include/generated/utsrelease.h'; mkdir -p 
include/generated/; 	if [ `echo -n "2.6.36-rc3+" | wc -c ` -gt 64 ]; 
then echo '"2.6.36-rc3+" exceeds 64 characters' >&2; exit 1; fi; (echo 
\#define UTS_RELEASE \"2.6.36-rc3+\";) < include/config/kernel.release > 
include/generated/utsrelease.h.tmp; if [ -r 
include/generated/utsrelease.h ] && cmp -s 
include/generated/utsrelease.h include/generated/utsrelease.h.tmp; then 
rm -f include/generated/utsrelease.h.tmp; else : '  UPD 
include/generated/utsrelease.h'; mv -f 
include/generated/utsrelease.h.tmp include/generated/utsrelease.h; fi
mkdir -p .tmp_versions ; rm -f .tmp_versions/*
make -f scripts/Makefile.build obj=scripts/basic
(cat /dev/null; ) > scripts/basic/modules.order
rm -f .tmp_quiet_recordmcount
make -f scripts/Makefile.build obj=.
(cat /dev/null; ) > modules.order
mkdir -p kernel/
mkdir -p arch/x86/kernel/
make -f scripts/Makefile.build obj=. missing-syscalls
   /bin/bash scripts/checksyscalls.sh gcc -Wp,-MD,./.missing-syscalls.d 
  -nostdinc -isystem /usr/lib/gcc/i486-linux-gnu/4.4.3/include 
-I/usr/src/tuxonice-head/arch/x86/include -Iinclude  -include 
include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 
-freg-struct-return -mpreferred-stack-boundary=2 -march=i686 
-mtune=pentium4 -mtune=generic -Wa,-mtune=generic32 -ffreestanding 
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack 
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)" 
-D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/mod
(cat /dev/null; ) > scripts/mod/modules.order
   gcc -Wp,-MD,scripts/mod/.empty.o.d  -nostdinc -isystem 
/usr/lib/gcc/i486-linux-gnu/4.4.3/include 
-I/usr/src/tuxonice-head/arch/x86/include -Iinclude  -include 
include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 
-freg-struct-return -mpreferred-stack-boundary=2 -march=i686 
-mtune=pentium4 -mtune=generic -Wa,-mtune=generic32 -ffreestanding 
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack 
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(empty)" 
-D"KBUILD_MODNAME=KBUILD_STR(empty)"  -c -o scripts/mod/empty.o 
scripts/mod/empty.c
   scripts/mod/mk_elfconfig < scripts/mod/empty.o > scripts/mod/elfconfig.h
Error: input truncated
make[2]: *** [scripts/mod/elfconfig.h] Error 1
make[1]: *** [scripts/mod] Error 2
make: *** [scripts] Error 2

Regards,

Nigel
