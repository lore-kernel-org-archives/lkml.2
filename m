Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab2BOJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:22:53 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55150 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab2BOJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:22:51 -0500
Message-ID: <4F3B7963.9080505@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 14:52:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/12] arch/sparc: remove references to cpu_*_map.
References: <1329281884.6232.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.6232.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021423-9264-0000-0000-000000D5EB26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 10:28 AM, Rusty Russell wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Also get rid of obsolescent first_cpu().
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> ---
>  arch/sparc/kernel/leon_kernel.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
> --- a/arch/sparc/kernel/leon_kernel.c
> +++ b/arch/sparc/kernel/leon_kernel.c
> @@ -104,11 +104,11 @@ static int irq_choose_cpu(const struct c
>  {
>  	cpumask_t mask;
>  
> -	cpus_and(mask, cpu_online_map, *affinity);
> -	if (cpus_equal(mask, cpu_online_map) || cpus_empty(mask))
> +	cpumask_and(&mask, cpu_online_mask, affinity);
> +	if (cpumask_equal(&mask, cpu_online_mask) || cpus_empty(mask))


You could even change that cpus_empty() to cpumask_empty(&mask)...
Either way, it is fine..

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

