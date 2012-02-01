Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2BAU3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:29:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:44646 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2BAU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:29:11 -0500
Message-ID: <4F29A072.9050203@windriver.com>
Date: Wed, 1 Feb 2012 15:28:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <paulus@samba.org>, <anton@samba.org>, <ben@decadent.org.uk>,
        <mikey@neuling.org>
Subject: Re: [PATCH] powerpc: Define cpus_in_crash only for SMP kernels
References: <20120201185510.GA8542@linux.vnet.ibm.com>
In-Reply-To: <20120201185510.GA8542@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-01 01:55 PM, Paul E. McKenney wrote:
> The variable cpus_in_crash gets a defined-but-not-used warning when
> CONFIG_SMP=n, so fix by placing the variable under ifdef.

I think Ben already merged a similar fix.

http://patchwork.ozlabs.org/patch/136549/

P.

> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index 28be345..eb3384e 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -46,7 +46,9 @@
>  
>  /* This keeps a track of which one is the crashing cpu. */
>  int crashing_cpu = -1;
> +#ifdef CONFIG_SMP
>  static atomic_t cpus_in_crash;
> +#endif /* #ifdef CONFIG_SMP */
>  static int time_to_dump;
>  
>  #define CRASH_HANDLER_MAX 3
> 
