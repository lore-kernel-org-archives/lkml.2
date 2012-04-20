Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2DTICk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:02:40 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60216 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2DTICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:02:36 -0400
Message-ID: <4F9117F6.4030808@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 13:31:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konrad Eisele <konrad@gaisler.com>
CC: davem@davemloft.net, yong.zhang0@gmail.com, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, daniel@gaisler.com
Subject: Re: [PATCH] sparc32,leon: add notify_cpu_starting()
References: <20120420.030607.1891260321280604674.davem@davemloft.net> <1334907995-6971-1-git-send-email-konrad@gaisler.com>
In-Reply-To: <1334907995-6971-1-git-send-email-konrad@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041921-1396-0000-0000-000001039C18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 01:16 PM, Konrad Eisele wrote:

> Otherwise cpu_active_mask will not set, which lead to other issue.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Signed-off-by: Konrad Eisele <konrad@gaisler.com>


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Looks like I missed sparc32 while fixing up the other architectures.
(https://lkml.org/lkml/2012/3/22/132)

Regards,
Srivatsa S. Bhat

> ---
>  arch/sparc/kernel/leon_smp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
> index 6173f4d..356dfc4 100644
> --- a/arch/sparc/kernel/leon_smp.c
> +++ b/arch/sparc/kernel/leon_smp.c
> @@ -79,6 +79,8 @@ void __cpuinit leon_callin(void)
>  	local_flush_tlb_all();
>  	leon_configure_cache_smp();
> 
> +	notify_cpu_starting(cpuid);
> +
>  	/* Get our local ticker going. */
>  	register_percpu_ce(cpuid);
> 

