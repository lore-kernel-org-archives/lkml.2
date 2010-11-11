Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0KKQSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:18:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42384 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0KKQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iCGtmyoK9QPD86jiOt1URtJzQD172riyucvpUj75ZNAjnH0TPYS0WgeR2GiF2zLecD
         wdaLk/HeZWFfoTnqBHbPtJpzsiGYEEBCfefl7czRk4QRNDkLk8tTGzu6rCbXrHx5hZKg
         D1bmcAforX5bqhmV7gYiya9f/3eqxKW1UkK0E=
Date: Thu, 11 Nov 2010 19:18:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH 3/9] x86: Make
	default_send_IPI_mask_sequence/allbutself_logical() 32bit only
Message-ID: <20101111161817.GA6517@lenovo>
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289473363-29440-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:02:37PM +0100, Tejun Heo wrote:
> Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
> This is to prepare for logical apicid handling update.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/kernel/apic/ipi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index 08385e0..5037736 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -56,6 +56,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_X86_32
> +
>  void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
>  						 int vector)

It still remains defined in ipi.h as external symbol without CONFIG_X86_32.

 Cyrill
