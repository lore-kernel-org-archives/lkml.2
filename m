Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1EaCXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:23:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57526 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EaCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:23:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE45119.9040108@jp.fujitsu.com>
Date: Tue, 31 May 2011 11:23:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rakib.mullick@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
References: <1306774744.4061.5.camel@localhost.localdomain>
In-Reply-To: <1306774744.4061.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 20c18b7..72cf857 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -461,7 +461,11 @@ void refresh_cpu_vm_stats(int cpu)
>  				p->expire = 3;
>  #endif
>  			}
> +
> +#ifndef CONFIG_PREEMPT
>  		cond_resched();
> +#endif
> +

In general, we should avoid #ifdef CONFIG_PREEMPT for maintainancebility as far as possible.
Is there any observable benefit? Can you please demonstrate it?



