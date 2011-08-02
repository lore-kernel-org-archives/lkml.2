Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1HBKze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:55:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60167 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1HBKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:55:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E37D791.5070804@jp.fujitsu.com>
Date: Tue, 02 Aug 2011 19:55:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: julia@diku.dk
CC: takata@linux-m32r.org, trivial@kernel.org, kernel-janitors@vger.kernel.org,
        akpm@linux-foundation.org, benh@kernel.crashing.org,
        jesper.nilsson@axis.com, cmetcalf@tilera.com,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/11] arch/m32r/kernel/smp.c: trivial: use BUG_ON
References: <1312281304-11847-1-git-send-email-julia@diku.dk> <1312281304-11847-8-git-send-email-julia@diku.dk>
In-Reply-To: <1312281304-11847-8-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/02 19:35), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> 
> @@ identifier x; @@
> -if (!x) BUG();
> +BUG_ON(!x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Indeed.
 Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> ---
>  arch/m32r/kernel/smp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -u -p a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
> --- a/arch/m32r/kernel/smp.c
> +++ b/arch/m32r/kernel/smp.c
> @@ -327,8 +327,7 @@ void smp_flush_tlb_page(struct vm_area_s
>  	cpumask_clear_cpu(cpu_id, &cpu_mask);
>  
>  #ifdef DEBUG_SMP
> -	if (!mm)
> -		BUG();
> +	BUG_ON(!mm);
>  #endif
>  
>  	if (*mmc != NO_CONTEXT) {
> 
> 
> 


