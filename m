Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1ITAvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 20:51:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1ITAvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 20:51:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=g1J72YwncVOUiCVzMLCin+UiWgjJTahSEfGocjhEIs4c0YCB31siXsFjpROHCk26P
	zmQkBN6hEA1UFaD2D2I7w==
Date: Mon, 19 Sep 2011 17:51:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH] x86: use the same node_distance for 32 and 64-bit
In-Reply-To: <201109191603.15560.hartleys@visionengravers.com>
Message-ID: <alpine.DEB.2.00.1109191748170.8943@chino.kir.corp.google.com>
References: <201109191603.15560.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, H Hartley Sweeten wrote:

> The node_distance function is not x86 64-bit specific.  Having the #ifdef
> around the extern function declaration and the #define causes the default
> node_distance macro to be used in asm-generic/topology.h. This also causes
> a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:
> 
> warning: symbol '__node_distance' was not declared. Should it be static?
> 
> Remove the #ifdef to fix both issues.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>

 [ I think kernel.org emails are still down, so I sent this to
   htejun@gmail.com instead. ]

Acked-by: David Rientjes <rientjes@google.com>

> ---
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index c006924..800f77c 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
>  	.balance_interval	= 1,					\
>  }
>  
> -#ifdef CONFIG_X86_64
>  extern int __node_distance(int, int);
>  #define node_distance(a, b) __node_distance(a, b)
> -#endif
>  
>  #else /* !CONFIG_NUMA */
>  
