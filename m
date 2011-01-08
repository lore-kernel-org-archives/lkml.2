Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1AHJW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 04:22:29 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:34466 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1AHJWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 04:22:25 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn> <201101070118.41900.arnd@arndb.de>
In-Reply-To: <201101070118.41900.arnd@arndb.de>
Subject: RE: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
Date: Sat, 8 Jan 2011 17:22:17 +0800
Message-ID: <023801cbaf15$8c569690$a503c3b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEfSwmwFZxtPXz+EiWqnhCTy4B4ZAFt5nGIlRQeJTA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, January 07, 2011 8:19 AM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
> 
> On Saturday 25 December 2010, Guan Xuetao wrote:
> > From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> >
> > This patch implements build infrastructure.
> 
> Sorry for the late reply, I was planning to do the new review earlier, but didn't
> get to it before the Christmas break.
Thanks for your review.

> 
> Overall, I can see that there has been a lot of good progress in the code since
> the original versions that I looked at, very nice!
> 
> > diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
> > new file mode 100644
> > index 0000000..f0fc866
> > --- /dev/null
> > +++ b/arch/unicore32/.gitignore
> > @@ -0,0 +1,70 @@
> > +#
> > +# Generated include files
> > +#
> > +include/asm/atomic.h
> > +include/asm/auxvec.h
> > +include/asm/bitsperlong.h
> > +include/asm/bug.h
> > +include/asm/bugs.h
> > +include/asm/cputime.h
> > +include/asm/current.h
> > +include/asm/device.h
> > +include/asm/emergency-restart.h
> > +include/asm/errno.h
> > +include/asm/fb.h
> > +include/asm/fcntl.h
> > +include/asm/hardirq.h
> > ...
> 
> Maybe it would be better to put these files into a separate directory, like
> arch/unicore32/include/generated/asm, to make it easier to separate them
> from the other files and avoid listing them all in .gitignore besides the
> other places.

That's great, and I make the following changes:

commit 2319043024c3db0eedfadf63b37714e14325104d
Author: GuanXuetao <gxt@mprc.pku.edu.cn>
Date:   Sat Jan 8 16:12:47 2011 +0800

    unicore32: move one-line asm-generic headers into arch/unicore32/include/generated/asm
    	however, 'make headers_install' can't work with two asm dirs

diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
index 815fad5..947e99c 100644
--- a/arch/unicore32/.gitignore
+++ b/arch/unicore32/.gitignore
@@ -1,57 +1,7 @@
 #
 # Generated include files
 #
-include/asm/atomic.h
-include/asm/auxvec.h
-include/asm/bitsperlong.h
-include/asm/bug.h
-include/asm/bugs.h
-include/asm/cputime.h
-include/asm/current.h
-include/asm/device.h
-include/asm/div64.h
-include/asm/emergency-restart.h
-include/asm/errno.h
-include/asm/fb.h
-include/asm/fcntl.h
-include/asm/hardirq.h
-include/asm/hw_irq.h
-include/asm/ioctl.h
-include/asm/ioctls.h
-include/asm/ipcbuf.h
-include/asm/irq_regs.h
-include/asm/kdebug.h
-include/asm/kmap_types.h
-include/asm/local.h
-include/asm/mman.h
-include/asm/module.h
-include/asm/msgbuf.h
-include/asm/param.h
-include/asm/parport.h
-include/asm/percpu.h
-include/asm/poll.h
-include/asm/posix_types.h
-include/asm/resource.h
-include/asm/scatterlist.h
-include/asm/sections.h
-include/asm/sembuf.h
-include/asm/serial.h
-include/asm/shmbuf.h
-include/asm/shmparam.h
-include/asm/siginfo.h
-include/asm/signal.h
-include/asm/socket.h
-include/asm/sockios.h
-include/asm/statfs.h
-include/asm/termbits.h
-include/asm/termios.h
-include/asm/topology.h
-include/asm/types.h
-include/asm/ucontext.h
-include/asm/unaligned.h
-include/asm/user.h
-include/asm/vga.h
-include/asm/xor.h
+include/generated
 #
 # Generated ld script file
 #
diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
index 8718152..2e03fae 100644
--- a/arch/unicore32/Makefile
+++ b/arch/unicore32/Makefile
@@ -60,60 +60,33 @@ all:	$(KBUILD_IMAGE)
 
 boot := arch/unicore32/boot
 
-ASM_GENERIC_HEADERS	:= arch/unicore32/include/asm/atomic.h			\
-			   arch/unicore32/include/asm/auxvec.h			\
-			   arch/unicore32/include/asm/bitsperlong.h		\
-			   arch/unicore32/include/asm/bug.h			\
-			   arch/unicore32/include/asm/bugs.h			\
-			   arch/unicore32/include/asm/cputime.h			\
-			   arch/unicore32/include/asm/current.h			\
-			   arch/unicore32/include/asm/device.h			\
-			   arch/unicore32/include/asm/div64.h			\
-			   arch/unicore32/include/asm/emergency-restart.h	\
-			   arch/unicore32/include/asm/errno.h			\
-			   arch/unicore32/include/asm/fb.h			\
-			   arch/unicore32/include/asm/fcntl.h			\
-			   arch/unicore32/include/asm/hardirq.h			\
-			   arch/unicore32/include/asm/hw_irq.h			\
-			   arch/unicore32/include/asm/ioctl.h			\
-			   arch/unicore32/include/asm/ioctls.h			\
-			   arch/unicore32/include/asm/ipcbuf.h			\
-			   arch/unicore32/include/asm/irq_regs.h		\
-			   arch/unicore32/include/asm/kdebug.h			\
-			   arch/unicore32/include/asm/kmap_types.h		\
-			   arch/unicore32/include/asm/local.h			\
-			   arch/unicore32/include/asm/mman.h			\
-			   arch/unicore32/include/asm/module.h			\
-			   arch/unicore32/include/asm/msgbuf.h			\
-			   arch/unicore32/include/asm/param.h			\
-			   arch/unicore32/include/asm/parport.h			\
-			   arch/unicore32/include/asm/percpu.h			\
-			   arch/unicore32/include/asm/poll.h			\
-			   arch/unicore32/include/asm/posix_types.h		\
-			   arch/unicore32/include/asm/resource.h		\
-			   arch/unicore32/include/asm/scatterlist.h		\
-			   arch/unicore32/include/asm/sections.h		\
-			   arch/unicore32/include/asm/sembuf.h			\
-			   arch/unicore32/include/asm/serial.h			\
-			   arch/unicore32/include/asm/shmbuf.h			\
-			   arch/unicore32/include/asm/shmparam.h		\
-			   arch/unicore32/include/asm/siginfo.h			\
-			   arch/unicore32/include/asm/signal.h			\
-			   arch/unicore32/include/asm/socket.h			\
-			   arch/unicore32/include/asm/sockios.h			\
-			   arch/unicore32/include/asm/statfs.h			\
-			   arch/unicore32/include/asm/termbits.h		\
-			   arch/unicore32/include/asm/termios.h			\
-			   arch/unicore32/include/asm/topology.h		\
-			   arch/unicore32/include/asm/types.h			\
-			   arch/unicore32/include/asm/ucontext.h		\
-			   arch/unicore32/include/asm/unaligned.h		\
-			   arch/unicore32/include/asm/user.h			\
-			   arch/unicore32/include/asm/vga.h			\
-			   arch/unicore32/include/asm/xor.h
+ASM_GENERATED_DIR	:= $(srctree)/arch/unicore32/include/generated
+LINUXINCLUDE		+= -I$(ASM_GENERATED_DIR)
+
+ASM_GENERIC_HEADERS	:= atomic.h auxvec.h				\
+			   bitsperlong.h bug.h bugs.h			\
+			   cputime.h current.h				\
+			   device.h div64.h				\
+			   emergency-restart.h errno.h			\
+			   fb.h	fcntl.h					\
+			   hardirq.h hw_irq.h				\
+			   ioctl.h ioctls.h ipcbuf.h irq_regs.h		\
+			   kdebug.h kmap_types.h			\
+			   local.h					\
+			   mman.h module.h msgbuf.h			\
+			   param.h parport.h percpu.h poll.h posix_types.h \
+			   resource.h					\
+			   scatterlist.h sections.h sembuf.h serial.h	\
+			   shmbuf.h shmparam.h siginfo.h signal.h	\
+			   socket.h sockios.h statfs.h			\
+			   termbits.h termios.h topology.h types.h	\
+			   ucontext.h unaligned.h user.h		\
+			   vga.h					\
+			   xor.h
 
 %.h:
-	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $@
+	$(Q)mkdir -p $(ASM_GENERATED_DIR)/asm
+	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $(ASM_GENERATED_DIR)/asm/$@
 
 archprepare: $(ASM_GENERIC_HEADERS)
 
@@ -126,7 +99,7 @@ zImage Image uImage: vmlinux
 zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-CLEAN_FILES += $(ASM_GENERIC_HEADERS)
+MRPROPER_DIRS	+= $(ASM_GENERATED_DIR)
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:

However, 'make headers_install' can't work with two asm dirs.
The ugly alternative method is copying all files in arch/unicore32/include/asm
to arch/unicore32/include/generated/asm. Then using the latter for headers_install.

> 
> It's certainly good to see so many of these files.
> 
> > +config GENERIC_GPIO
> > +	def_bool y
> > +
> > +config GENERIC_CLOCKEVENTS
> > +	bool
> > +
> > +config NO_IOPORT
> > +	bool
> > +
> > +config GENERIC_HARDIRQS
> > +	bool
> > +	default y
> 
> You are somewhat inconsistent with "def_bool", "default y" and "select FOO",
> which all have the same effect. I would recommend using def_bool y where
> possible.
Ok.

> 
> > +config REALMODE
> > +	bool
> 
> I don't see this being used anywhere. Is it just a leftover from an earlier
> version, or did I miss something?
Removed.

> 
> > +choice
> > +	prompt "PKUnity system type"
> > +	default ARCH_PUV3
> > +
> > +	config ARCH_PUV3
> > +	bool "PKUnity v3 (SuperK)"
> > +	select CPU_UCV2
> > +	select GENERIC_CLOCKEVENTS
> > +	select HAVE_CLK
> > +	select ARCH_REQUIRE_GPIOLIB
> > +	select ARCH_HAS_CPUFREQ
> > +
> > +endchoice
> 
> As long as there is only one option, you can drop the entire "choice"
> statement.
Ok.

> 
> > +config DEBUG_USER
> > +	bool "Verbose user fault messages"
> > +	help
> > +	  When a user program crashes due to an exception, the kernel can
> > +	  print a brief message explaining what the problem was. This is
> > +	  sometimes helpful for debugging but serves no purpose on a
> > +	  production system. Most people should say N here.
> > +
> > +	  In addition, you need to pass user_debug=N on the kernel command
> > +	  line to enable this feature.  N consists of the sum of:
> > +
> > +	      1 - undefined instruction events
> > +	      2 - system calls
> > +	      4 - invalid data aborts
> > +	      8 - SIGSEGV faults
> > +	     16 - SIGBUS faults
> 
> We already have four architectures doing this using the "exception-trace"
> sysctl and the show_unhandled_signals variable. Please follow what those
> architectures are doing, or remove the option and all code depending on
> it.
Removed now.

> 
> 
> 	Arnd
Thanks Arnd.

Guan Xuetao

