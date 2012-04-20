Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2DTHgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:36:04 -0400
Received: from mail176c2.megamailservers.com ([69.49.111.76]:57815 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab2DTHgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:36:01 -0400
X-Greylist: delayed 3447 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 03:36:01 EDT
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4F910312.3010900@gaisler.com>
Date: Fri, 20 Apr 2012 08:32:50 +0200
From: Konrad Eisele <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: sam@ravnborg.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, daniel@gaisler.com,
        Yong Zhang <yong.zhang@windriver.com>
Subject: Re: [PATCH 1/1] sparc32,leon: add notify_cpu_starting()
References: <20120420033634.GA13068@zhy> <1334903312-18526-1-git-send-email-konrad@gaisler.com>
In-Reply-To: <1334903312-18526-1-git-send-email-konrad@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=r1DLTJ6I4WNtNSDbWOfumzxcbMy5NL/NTCl1I6dcIeE= c=1 sm=1
		a=WtivZnh1UKgA:10 a=0Wa5ieas-ecA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=t7CeM3EgAAAA:8 a=pGLkceISAAAA:8
		a=ebG-ZW-8AAAA:8 a=Q_KVjGDA7x4jA4h9jjsA:9 a=wPNLvfGTeEIA:10
		a=2e6ZYRoF4I4A:10 a=MSl-tDqOz04A:10 a=cCYF7-FHeg4A:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020203.4F91055B.001F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WHL: SLR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yong,
Thank you for the patch, it works. The SMP is fully
functional again for sparc-leon. I just added a "#include<linux/cpu.h>"
to avoid compiler warning.
Please someone in the cc-list, apply.
-- Greetings Konrad

Konrad Eisele wrote:
> From: Yong Zhang<yong.zhang@windriver.com>
>
> Otherwise cpu_active_mask will not set, which lead to other issue.
>
> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
> Signed-off-by: Konrad Eisele<konrad@gaisler.com>
> ---
>   arch/sparc/kernel/leon_smp.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
> index 1210fde..160cac9 100644
> --- a/arch/sparc/kernel/leon_smp.c
> +++ b/arch/sparc/kernel/leon_smp.c
> @@ -23,6 +23,7 @@
>   #include<linux/pm.h>
>   #include<linux/delay.h>
>   #include<linux/gfp.h>
> +#include<linux/cpu.h>
>
>   #include<asm/cacheflush.h>
>   #include<asm/tlbflush.h>
> @@ -78,6 +79,8 @@ void __cpuinit leon_callin(void)
>   	local_flush_tlb_all();
>   	leon_configure_cache_smp();
>
> +	notify_cpu_starting(cpuid);
> +
>   	/* Get our local ticker going. */
>   	smp_setup_percpu_timer();
>

