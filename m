Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0JVNn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:43:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:55192 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab0JVNnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:43:25 -0400
/m: 
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Oct 2010 15:43:22 +0200
From: Richard Weinberger <richard@nod.at>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>
Cc: <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:irq/core] genirq: Warn if enable_irq is called before irq is
 set up
In-Reply-To: <tip-658fc358f9954083ea55abf82ca77a18f82412d7@git.kernel.org>
References: <tip-658fc358f9954083ea55abf82ca77a18f82412d7@git.kernel.org>
Message-ID: <2ae2295020fc2c103ca624e08e43c849@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 13:09:49 GMT, tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:
> Commit-ID:  658fc358f9954083ea55abf82ca77a18f82412d7
> Gitweb:    
> http://git.kernel.org/tip/658fc358f9954083ea55abf82ca77a18f82412d7
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 22 Oct 2010 14:47:57 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Fri, 22 Oct 2010 15:05:35 +0200
> 
> genirq: Warn if enable_irq is called before irq is set up
> 
> The recent changes in the genirq core unearthed a bug in arch/um which
> called enable_irq() before the interrupt was set up. 
> 
> Warn and return instead of crashing the machine with a NULL pointer
> dereference.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Weinberger <richard@nod.at>
> ---
>  kernel/irq/manage.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 644e8d5..2806023 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -324,6 +324,10 @@ void enable_irq(unsigned int irq)
>  	if (!desc)
>  		return;
>  
> +	if (WARN(!desc->irq_data.chip || !desc->irq_data.chip->irq_enable,
> +	    "KERN_ERR enable_irq before setup/request_irq: irq %u\n", irq))

Here is a little typo. The double quote should be after KERN_ERR.

Thanks,
//richard

> +		return;
> +
>  	chip_bus_lock(desc);
>  	raw_spin_lock_irqsave(&desc->lock, flags);
>  	__enable_irq(desc, irq, false);

