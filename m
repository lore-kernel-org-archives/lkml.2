Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2DTH5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:57:38 -0400
Received: from mail202c2.megamailservers.com ([69.49.111.103]:55981 "EHLO
	mail202c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab2DTH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:57:36 -0400
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4F91149D.1010906@gaisler.com>
Date: Fri, 20 Apr 2012 09:47:41 +0200
From: Konrad Eisele <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Konrad Eisele <konrad@gaisler.com>
CC: davem@davemloft.net, yong.zhang0@gmail.com, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, daniel@gaisler.com
Subject: Re: [PATCH] sparc32,leon: add notify_cpu_starting()
References: <20120420.030607.1891260321280604674.davem@davemloft.net> <1334907995-6971-1-git-send-email-konrad@gaisler.com>
In-Reply-To: <1334907995-6971-1-git-send-email-konrad@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.4F9116E6.002D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WHL: SLR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version is against linux/kernel/git/davem/sparc-next.git .
-- Konrad

Konrad Eisele wrote:
> Otherwise cpu_active_mask will not set, which lead to other issue.
>
> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
> Signed-off-by: Konrad Eisele<konrad@gaisler.com>
> ---
>   arch/sparc/kernel/leon_smp.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
> index 6173f4d..356dfc4 100644
> --- a/arch/sparc/kernel/leon_smp.c
> +++ b/arch/sparc/kernel/leon_smp.c
> @@ -79,6 +79,8 @@ void __cpuinit leon_callin(void)
>   	local_flush_tlb_all();
>   	leon_configure_cache_smp();
>
> +	notify_cpu_starting(cpuid);
> +
>   	/* Get our local ticker going. */
>   	register_percpu_ce(cpuid);
>

