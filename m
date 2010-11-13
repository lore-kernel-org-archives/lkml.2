Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0KML7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:59:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59327 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab0KML7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:references:in-reply-to:x-enigmail-version
         :content-type:content-transfer-encoding;
        b=a1TV6Wl1BnPIcxBy+BFf52Zq0WS1BwYKavZ1MKLb88xVx+BTp4ScDV69IPNIvuSAKR
         4w8W4kwoP6HmgnPcEYeYT7n4FH5Wf19cegTRuAse5im8bBRE+2IXSTXOjtnAwbAklIRd
         oDrmLDsA1dALvyyltiIzheNO4tzN8PPQZhe9I=
Message-ID: <4CDE7D65.6060203@gmail.com>
Date: Sat, 13 Nov 2010 17:28:29 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [PATCH 2.6.36 1/1] kernel SPIN_LOCK_UNLOCKED changed to __SPIN_LOCK_UNLOCKED()
References: <4CD823DC.8030201@gmail.com>
In-Reply-To: <4CD823DC.8030201@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atul Sowani wrote:
> There are still some files containing .lock = SPIN_LOCK_UNLOCKED type
> assignments which should be converted to __SPIN_LOCK_UNLOCKED().
> 
> Signed-off-by: Atul Sowani <sowani@gmail.com>
> ---
> 
> diff -uprN a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> --- a/arch/arm/kernel/smp.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/arch/arm/kernel/smp.c	2010-11-07 00:47:32.000000000 +0530
> @@ -56,7 +56,7 @@ struct ipi_data {
>  };
> 
>  static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> -	.lock	= SPIN_LOCK_UNLOCKED,
> +	.lock	= __SPIN_LOCK_UNLOCKED (ipi_data.lock),
>  };
> 
>  enum ipi_msg_type {
> diff -uprN a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
> --- a/arch/mips/kernel/vpe.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/arch/mips/kernel/vpe.c	2010-11-07 00:51:37.000000000 +0530
> @@ -148,9 +148,9 @@ struct {
>  	spinlock_t tc_list_lock;
>  	struct list_head tc_list;	/* Thread contexts */
>  } vpecontrol = {
> -	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
> +	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.vpe_list_lock),
>  	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
> -	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
> +	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.tc_list_lock),
>  	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
>  };
> diff -uprN a/kernel/cred.c b/kernel/cred.c
> --- a/kernel/cred.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/kernel/cred.c	2010-11-07 00:52:22.000000000 +0530
> @@ -35,7 +35,7 @@ static struct kmem_cache *cred_jar;
>  static struct thread_group_cred init_tgcred = {
>  	.usage	= ATOMIC_INIT(2),
>  	.tgid	= 0,
> -	.lock	= SPIN_LOCK_UNLOCKED,
> +	.lock	= __SPIN_LOCK_UNLOCKED(init_tgcred.lock),
>  };
>  #endif
> 

Hi all,

I made original patch submission on 08.Nov.2010. I am wondering if
this patch will be useful and is correct. Please comment.

Best regards,
Atul.

-- 
Atul Sowani (sowani@gmail.com)
http://savannah.gnu.org/users/atul
------------------------------------------------------------------------
