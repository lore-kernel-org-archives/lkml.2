Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2LMChA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:37:00 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36806 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756539Ab2LMC0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:26:54 -0500
Message-ID: <1355365612.2164.17.camel@joe-AO722>
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= [TRIVIAL PATCH 15/26]
 unicore32: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: "'Jiri Kosina'" <trivial@kernel.org>, linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 18:26:52 -0800
In-Reply-To: <001d01cdd8cd$371dfd60$a559f820$@mprc.pku.edu.cn>
References: <cover.1355335227.git.joe@perches.com>
	 <19e6ea369e4455fc447c48f72bd433921bd0a703.1355335228.git.joe@perches.com>
	 <001d01cdd8cd$371dfd60$a559f820$@mprc.pku.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 09:00 +0800, Guan Xuetao wrote:
> 确认下面的patch可以正常编译，无warning信息

There is no unicore32 cross compiler available
on kernel.org.

ftp://ftp.kernel.org/pub/tools/crosstool/index.html

These are unsigned long cast to (void *)
What is the warning and how does it differ
from any existing warning?

> > diff --git a/arch/unicore32/kernel/process.c
[]
> > @@ -169,8 +169,9 @@ void __show_regs(struct pt_regs *regs)
> >  		init_utsname()->release,
> >  		(int)strcspn(init_utsname()->version, " "),
> >  		init_utsname()->version);
> > -	print_symbol("PC is at %s\n", instruction_pointer(regs));
> > -	print_symbol("LR is at %s\n", regs->UCreg_lr);
> > +	printk(KERN_DEFAULT "PC is at %pSR\n",
> > +	       (void *)instruction_pointer(regs));
> > +	printk(KERN_DEFAULT "LR is at %pSR\n", (void *)regs->UCreg_lr);
> >  	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr:
> %08lx\n"
> >  	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
> >  		regs->UCreg_pc, regs->UCreg_lr, regs->UCreg_asr,


