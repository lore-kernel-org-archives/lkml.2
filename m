Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1KURbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:31:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1KURbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:31:00 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7A_0Q1ebongA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=z2W-X94jAAAA:8 a=5H7RWHWPmeIPUf3NCNQA:9 a=PCbNFfLSDXog9KclGEkA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [ANNOUNCE] 3.2-rc1-rt1 - Compile errors also for rc1 vanilla
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <201111141014.06906.tim.sander@hbm.com>
References: <alpine.LFD.2.02.1111132213220.2694@ionos>
	 <201111141014.06906.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 12:30:57 -0500
Message-ID: <1321896657.20742.16.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 10:14 +0100, Tim Sander wrote:
> Hi Thomas
> 
> > I'm pleased to announce the 3.2-rc1-rt1 release.
> Thanks for that.
>  
> > It's a straight forward port of the 3.0-rt patch queue, which reduced
> > the patch size by more than 25% from 807k to 580k. The diffstat change
> > is:
> > 
> >  429 files changed, 10118 insertions(+), 3000 deletions(-)
> >  318 files changed,  8871 insertions(+), 1858 deletions(-)
> > 
> > Thanks to all who helped polishing patches and bringing them mainline!
> > 
> > 
> > The test results on my reference machine are in the 3.0-rt ballpark
> > and I have not seen any frightening explosions so far.
> 
> Well it seems as if  this guy which wanted to remove rcu finally succeded ;-)
> I can't select a rcu subsystem?

Is this just an issue in 3.2-rt, or did you see this issue in the 3.0-rt
release too. I used your attached config and crossed compiled with arm:

$ /usr/local/gcc-4.5.2-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-gcc --version
arm-unknown-linux-gnueabi-gcc (GCC) 4.5.2

and it finished fine with 3.0-rt, but when I compiled against both
3.2-rt1 and 3.2-rt3, I got the same error:

arch/arm/mach-imx/built-in.o: In function `imx31_soc_init':
/work/rt/rt.git/arch/arm/mach-imx/mm-imx3.c:186: undefined reference to `mx31_revision'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

Which is not the error you saw. I'm curious to what I did wrong.

Thanks,

-- Steve


> ----------------------
> target: kernel.compile
> ----------------------
> 
> cd /home/sander/speedy/trunk/ptx/platform-pmx-one/build-target/linux-linux && PATH=/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-
> cross/bin:/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-cross/sbin:$PATH KCONFIG_NOTIMESTAMP=1 make \
>                 -j16 HOSTCC=gcc ARCH=arm CROSS_COMPILE=arm-1136jfs-linux-gnueabi- INSTALL_MOD_PATH=/home/sander/speedy/trunk/ptx/platform-pmx-one/packages/linux-linux 
> PTX_KERNEL_DIR=/home/sander/speedy/trunk/ptx/platform-pmx-one/build-target/linux-linux CONFIG_DEBUG_SECTION_MISMATCH=y 
> DEPMOD=/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-cross/sbin/arm-1136jfs-linux-gnueabi-depmod uImage "modules"
> make[1]: Entering directory `/home/sander/speedy/trunk/ptx/kernel/linux'
> scripts/kconfig/conf --silentoldconfig Kconfig
> make[1]: Leaving directory `/home/sander/speedy/trunk/ptx/kernel/linux'
> make[1]: Entering directory `/home/sander/speedy/trunk/ptx/kernel/linux'
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[2]: `include/generated/mach-types.h' is up to date.
>   CC      arch/arm/kernel/asm-offsets.s
> In file included from include/linux/mm_types.h:15:0,
>                  from include/linux/sched.h:64,
>                  from arch/arm/kernel/asm-offsets.c:13:
> include/linux/rcupdate.h:223:2: error: #error "Unknown RCU implementation specified to kernel configuration"
> make[2]: *** [arch/arm/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make[1]: Leaving directory `/home/sander/speedy/trunk/ptx/kernel/linux'
> make: *** [/home/sander/speedy/trunk/ptx/platform-pmx-one/state/kernel.compile] Error 2
> 
> 
> When trying to select the rcu in the menuconfig it is not selectable :-(.
> 
> This is on freescale arm i.xm35 platform with local modifications for our own platform.
> 
> Havent tried to compile 3.2-rc1 without preempt but that fails with the following error:
> ----------------------
> target: kernel.compile
> ----------------------
> 
> cd /home/sander/speedy/trunk/ptx/platform-pmx-one/build-target/linux-linux && PATH=/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-
> cross/bin:/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-cross/sbin:$PATH KCONFIG_NOTIMESTAMP=1 make \
>                 -j16 HOSTCC=gcc ARCH=arm CROSS_COMPILE=arm-1136jfs-linux-gnueabi- INSTALL_MOD_PATH=/home/sander/speedy/trunk/ptx/platform-pmx-one/packages/linux-linux 
> PTX_KERNEL_DIR=/home/sander/speedy/trunk/ptx/platform-pmx-one/build-target/linux-linux CONFIG_DEBUG_SECTION_MISMATCH=y 
> DEPMOD=/home/sander/speedy/trunk/ptx/platform-pmx-one/sysroot-cross/sbin/arm-1136jfs-linux-gnueabi-depmod uImage "modules"
> make[1]: Entering directory `/home/sander/speedy/trunk/ptx/kernel/linux'
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[2]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
> <stdin>:1562:2: warning: #warning syscall process_vm_readv not implemented
> <stdin>:1566:2: warning: #warning syscall process_vm_writev not implemented
>   CHK     include/generated/compile.h
>   CC      arch/arm/plat-mxc/iomux-v3.o
>   CC      arch/arm/plat-mxc/ulpi.o
>   CC      arch/arm/plat-mxc/avic.o
>   CC      arch/arm/plat-mxc/audmux-v2.o
>   CC      arch/arm/plat-mxc/devices/platform-fec.o
>   CC      arch/arm/plat-mxc/devices/platform-flexcan.o
>   CC      arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.o
>   CC      arch/arm/plat-mxc/devices/platform-gpio-mxc.o
>   CC      arch/arm/plat-mxc/devices/platform-imx2-wdt.o
> arch/arm/plat-mxc/avic.c:154:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'avic_handle_irq'
> arch/arm/plat-mxc/avic.c:53:12: warning: 'avic_saved_mask_reg' defined but not used
> make[2]: *** [arch/arm/plat-mxc/avic.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> 
> Will there be still some consolidation for the 3.0 kernel. I really was hoping that the rt kernel still remains a little longer 
> on 3.0 since this seems to be a longer maintained kernel version for various groups?
> 
> Best regards
> Tim
> 
> please ignore the noise below, added automatically by mailserver:
> 
> Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 
> 
> Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
> Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster
> 
> Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
> Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster
> 
> The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.
> 
> Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.


