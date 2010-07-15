Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab0GOAd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:33:27 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:51389 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757300Ab0GOAd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:33:26 -0400
Message-ID: <4C3E5672.4090606@snapgear.com>
Date: Thu, 15 Jul 2010 10:29:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        John Kacur <jkacur@redhat.com>, Tejun Heo <tj@kernel.org>,
        Maxim Kuvyrkov <maxim@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] arch/m68knommu/kernel/process.c: formatting of
 pointers in printk()
References: <1279130473-10737-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1279130473-10737-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kulikov,

Kulikov Vasiliy wrote:
> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Do you want me to push this to Linus via the m68knommu git tree?

Regards
Greg



> ---
>  arch/m68knommu/kernel/process.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
> index 6aa6613..1096c0e 100644
> --- a/arch/m68knommu/kernel/process.c
> +++ b/arch/m68knommu/kernel/process.c
> @@ -316,14 +316,14 @@ void dump(struct pt_regs *fp)
>  		fp->d0, fp->d1, fp->d2, fp->d3);
>  	printk(KERN_EMERG "d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
>  		fp->d4, fp->d5, fp->a0, fp->a1);
> -	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %08x\n",
> -		(unsigned int) rdusp(), (unsigned int) fp);
> +	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %p\n",
> +		(unsigned int) rdusp(), fp);
>  
>  	printk(KERN_EMERG "\nCODE:");
>  	tp = ((unsigned char *) fp->pc) - 0x20;
>  	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
>  		if ((i % 0x10) == 0)
> -			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> +			printk(KERN_EMERG "%p: ", tp + i);
>  		printk("%08x ", (int) *sp++);
>  	}
>  	printk(KERN_EMERG "\n");
> @@ -332,7 +332,7 @@ void dump(struct pt_regs *fp)
>  	tp = ((unsigned char *) fp) - 0x40;
>  	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
>  		if ((i % 0x10) == 0)
> -			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> +			printk(KERN_EMERG "%p: ", tp + i);
>  		printk("%08x ", (int) *sp++);
>  	}
>  	printk(KERN_EMERG "\n");
> @@ -341,7 +341,7 @@ void dump(struct pt_regs *fp)
>  	tp = (unsigned char *) (rdusp() - 0x10);
>  	for (sp = (unsigned long *) tp, i = 0; (i < 0x80); i += 4) {
>  		if ((i % 0x10) == 0)
> -			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> +			printk(KERN_EMERG "%p: ", tp + i);
>  		printk("%08x ", (int) *sp++);
>  	}
>  	printk(KERN_EMERG "\n");


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
