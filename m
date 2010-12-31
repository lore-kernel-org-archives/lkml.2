Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0LaVkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 16:40:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0LaVkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 16:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sa5DCTdq9yTjz6CcKhTxQATDqBgywVpz9BYdQaRwJc79Tq3cuGhWuEuvEkVH3Dl5FU
         wbS61R8dkj+Sl5Yr6kajdjz+Eslz1GSN/AmubFhgKG9t+H8lZB2PtS34WnIQm114Ui0E
         o67o44dIeS/vddfuk1PYCm9B6WsEmRmTkk3x0=
Date: Fri, 31 Dec 2010 23:40:10 +0200
From: Yotam Medini <yotam.medini@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, Avery Pennarun <apenwarr@alumnit.ca>
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-ID: <20101231234010.0165f0e8@janini.home>
In-Reply-To: <20101231113954.dc9adbdf.rdunlap@xenotime.net>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
	<20101231212800.1e47f200@janini.home>
	<20101231113954.dc9adbdf.rdunlap@xenotime.net>
Reply-To: yotam.medini@gmail.com
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .config I ended up with does have:
   CONFIG_APM=m
But no CONFIG_APM_POWER setting, 
When booting the kernel, I don not have /proc/apm.
I do get:

  $ sudo modprobe apm
  FATAL: Error inserting apm 
    (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device

Please note that 
  drivers/power/Makefile:118
has:
  obj-$(CONFIG_APM_POWER) += apm_power.o

Also the "/proc/apm" is created in 
  drivers/char/Makefile:71
    obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
  drivers/char/apm-emulation.c:668-670
    #ifdef CONFIG_PROC_FS
	    proc_create("apm", 0, NULL, &apm_proc_fops);
    #endif
As far as I understand, CONFIG_APM is not sufficient 
for the creation of "/proc/apm".

-- yotam


On Fri, 31 Dec 2010 11:39:54 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Fri, 31 Dec 2010 21:28:00 +0200 Yotam Medini wrote:
> 
> > Randy,
> > 
> > Thanks for your quick reply.
> > Sorry, but the subject line should have been:
> >   APM_POWER on x86 - Is it possible?  
> 
> Nope, not on X86.
> 
> > I do get 
> >   CONFIG_APM=m
> > in the .config, but I am trying to get 
> >   CONFIG_APM_POWER=m
> > as well. So far, I do not see how.  
> 
> APM_POWER depends on APM_EMULATION, which is not available on X86.
> But real APM is available on X86, so why would you need APM_EMULATION
> instead of APM_FOR_REAL ?
> 
> Enabling APM (according to its Kconfig help text) provides /proc/apm
> battery status information.
> 

On Fri, 31 Dec 2010 11:25:04 -0800
Avery Pennarun <apenwarr@alumnit.ca> wrote:

> On Fri, Dec 31, 2010 at 4:09 AM, Yotam Medini יותם מדיני
> <yotam.medini@gmail.com> wrote:
> > For a target ancient UMAX-ActionBook 530T, I am trying to compile
> > a Linux kernel that will support apm (/proc/apm)
> > for battery monitoring.
> > Alas, it looks like that with current 2.6.3n.* kernels
> > it is not possible to configure CONFIG_APM_POWER on x86(/i386)
> > architectures.
> >
> > Am I missing something, is there a bypass?  
> 
> CONFIG_APM still exists and can be enabled in 2.6.36 for me.
> 
> Avery

