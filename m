Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2LMFCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:02:03 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:52719 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab2LMFCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:02:01 -0500
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <53832.162.105.80.111.1355375102.squirrel@mprc.pku.edu.cn>
In-Reply-To: <19e6ea369e4455fc447c48f72bd433921bd0a703.1355335228.git.joe@perches.c
     om>
References: <cover.1355335227.git.joe@perches.com>
    <19e6ea369e4455fc447c48f72bd433921bd0a703.1355335228.git.joe@perches.com>
Date: Thu, 13 Dec 2012 13:05:02 +0800 (CST)
Subject: Re: [TRIVIAL PATCH 15/26] unicore32: Convert print_symbol to %pSR
To: "Joe Perches" <joe@perches.com>
Cc: "Jiri Kosina" <trivial@kernel.org>, "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use the new vsprintf extension to avoid any possible
> message interleaving.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Sorry for my last email, which should not reply all.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/kernel/process.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/unicore32/kernel/process.c
> b/arch/unicore32/kernel/process.c
> index 62bad9f..d17a893 100644
> --- a/arch/unicore32/kernel/process.c
> +++ b/arch/unicore32/kernel/process.c
> @@ -169,8 +169,9 @@ void __show_regs(struct pt_regs *regs)
>  		init_utsname()->release,
>  		(int)strcspn(init_utsname()->version, " "),
>  		init_utsname()->version);
> -	print_symbol("PC is at %s\n", instruction_pointer(regs));
> -	print_symbol("LR is at %s\n", regs->UCreg_lr);
> +	printk(KERN_DEFAULT "PC is at %pSR\n",
> +	       (void *)instruction_pointer(regs));
> +	printk(KERN_DEFAULT "LR is at %pSR\n", (void *)regs->UCreg_lr);
>  	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
>  	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
>  		regs->UCreg_pc, regs->UCreg_lr, regs->UCreg_asr,
> --
> 1.7.8.112.g3fd21
>

