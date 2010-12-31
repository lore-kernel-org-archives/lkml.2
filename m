Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0LaT2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:28:00 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41619 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0LaT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:27:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:reply-to
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=N4jypW43Mzkrx6cci/VC0oP0qmrhjp4z5vXlukc01t54PeW/q6esrsGUYC7teVknZO
         ywfCNFu5xE5FbZ+w8o3ryp/UQL6vnVgy5QprKsZMJIH6yBPFB3Q1jp9y3itfCo50H3y9
         1dzGtGO1P6kz7AGvmNO3VSHL5ZOZhzGm3+N10=
Date: Fri, 31 Dec 2010 21:28:00 +0200
From: Yotam Medini <yotam.medini@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-ID: <20101231212800.1e47f200@janini.home>
In-Reply-To: <20101231103345.baba0f8c.rdunlap@xenotime.net>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
Reply-To: yotam.medini@gmail.com
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

Thanks for your quick reply.
Sorry, but the subject line should have been:
  APM_POWER on x86 - Is it possible?
I do get 
  CONFIG_APM=m
in the .config, but I am trying to get 
  CONFIG_APM_POWER=m
as well. So far, I do not see how.

regards -- yotam

On Fri, 31 Dec 2010 10:33:45 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Fri, 31 Dec 2010 19:38:58 +0200 Yotam Medini wrote:
> 
> > Hello,
> > 
> > To an ancient target (my UMAX 530T ActionBook - plz don't laugh...)
> > I am trying to build a lean kernel based on 2.6.32.24 (~ Ubuntu 10.04).
> > Battery monitoring used to be based on /proc/apm.
> > I believe ACPI is not supported on this old notebook.
> > Now, it seems that  CONFIG_APM_POWER  cannot be set, since:
> > 
> > 1. The configuration place for  APM_POWER  is in:
> >    ./drivers/power/Kconfig:25:
> > 	config APM_POWER
> > 		tristate "APM emulation for class batteries"
> > 		depends on APM_EMULATION
> > 
> > 2. The configuration place for  APM_EMULATION  is in:
> >     ./kernel/power/Kconfig:201:
> >     config APM_EMULATION
> > 	    tristate "Advanced Power Management Emulation"
> > 	    depends on PM && SYS_SUPPORTS_APM_EMULATION
> > 
> > 3. But the configuration places for the latter -  
> >       SYS_SUPPORTS_APM_EMULATION
> >   - exists only in:
> >     ./arch/powerpc/Kconfig:185:config SYS_SUPPORTS_APM_EMULATION
> >     ./arch/sh/Kconfig:120:config SYS_SUPPORTS_APM_EMULATION
> >     ./arch/mips/Kconfig:896:config SYS_SUPPORTS_APM_EMULATION
> >     ./arch/arm/Kconfig:32:config SYS_SUPPORTS_APM_EMULATION
> >   and none under arch/x86 ! :():
> > 
> > So my bottom line questions are:
> > + Am I missing something?
> > + What is the 'right way' to configure a 2.6.3m.nn kernel
> >   that should support battery monitoring on such ancient laptops.
> > 
> > When replying, please CC: yotam DOT medini AT Gmail DOT c0m
> > regards -- yotam
> > --
> 
> 
> arch/x86/Kconfig has the kconfig symbol "APM":
> 
> menuconfig APM
> 	tristate "APM (Advanced Power Management) BIOS support"
> 	depends on X86_32 && PM_SLEEP
> => /proc/apm for battery status information
> 
> so as long as your target system is 32-bit X86, you should be OK.
> 
> PM_SLEEP depends on SUSPEND || HIBERNATION.  PM needs to be enabled,
> and SWAP has to be enabled for HIBERNATION.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> desserts:  http://www.xenotime.net/linux/recipes/
