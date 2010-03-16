Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab0CPSoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:44:15 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:60072 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab0CPSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:44:13 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 14:44:13 EDT
Date: Tue, 16 Mar 2010 18:25:34 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Will L Givens <wlgivens@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: Will's kernel compilation error
Message-ID: <20100316182534.GA818@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de, Will L Givens <wlgivens@gmail.com>,
	linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001e01cac4cc$98072ce0$c81586a0$@com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 12:50:32AM -0500, Will L Givens wrote:
> > >  GEN     .version
> > >  CHK     include/generated/compile.h
> > >  UPD     include/generated/compile.h
> > >  CC      init/version.o
> > >  LD      init/built-in.o
> > >  LD      .tmp_vmlinux1
> > > kernel/built-in.o: In function `kthread_create':
> > > (.text+0x1ece4): relocation truncated to fit: GPREL16 against symbol
> > > `kthreadd_task' defined in .sbss section in kernel/built-in.o
> > > kernel/built-in.o: In function `check_cpu_itimer':
> > > (.text+0x21784): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `check_cpu_itimer':
> > > (.text+0x2179c): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `free_nsproxy':
> > > (.text+0x23064): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `create_new_namespaces':
> > > (.text+0x230a4): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `create_new_namespaces':
> > > (.text+0x23254): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `notify_die':
> > > (.text+0x2413c): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `register_die_notifier':
> > > (.text+0x241a4): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `unregister_die_notifier':
> > > (.text+0x241bc): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `sched_clock_init':
> > > (.text+0x24ba4): relocation truncated to fit: GPREL16 against `.sbss'
> > > kernel/built-in.o: In function `sched_clock_cpu':
> > > (.text+0x24bb4): additional relocation overflows omitted from the
> > output
> > > make: *** [.tmp_vmlinux1] Error 1
> 
> It seems the problem, GPREL16, is pretty wide spread. I've tried building
> the drivers as modules, since that doesn't appear to be a problem *knock on
> wood* but one driver after another, after another, after another generates a
> new GPREL16 error! Raid0 drivers, numerous NetFilter modules, IR drivers
> (guess I can't use a Hauppauge card), and various other components. I'm
> going to try a few more configurations... then hit the sack. I'm pretty sure
> this is going to be a long process.

when I hit the relocation overflow a couple of releases before, I locally
applied this patch, which fixes it for me. I assume the kernel is slightly
bigger this way, but I didn't measure it.

ev6, everything built in, gcc 4.4 I think

Thorsten


diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
index 4759fe7..2cc3cc5 100644
--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -12,7 +12,7 @@ NM := $(NM) -B
 
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
-cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
+cflags-y	:= -pipe -mno-fp-regs -ffixed-8
 cflags-y	+= $(call cc-option, -fno-jump-tables)
 
 cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4


-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
