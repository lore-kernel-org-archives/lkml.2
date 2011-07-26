Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1GZFaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:30:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49960 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1GZFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:30:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E2E507F.7030607@jp.fujitsu.com>
Date: Tue, 26 Jul 2011 14:28:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Like /proc/interrupts, no need to output data for nobody.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If the cpu never be onlined, its statistics always 0. Then, it definitely
no value. In the other hand, if the cpu was offlined dynamically, we don't
know the user want to know the cpus's statistics or not.

Anyway, it's incompatibility change. I don't think this is valuable change.


> ---
>  fs/proc/softirqs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
> index 62604be..2b32b46 100644
> --- a/fs/proc/softirqs.c
> +++ b/fs/proc/softirqs.c
> @@ -11,13 +11,13 @@ static int show_softirqs(struct seq_file *p, void *v)
>  	int i, j;
>  
>  	seq_puts(p, "                    ");
> -	for_each_possible_cpu(i)
> +	for_each_online_cpu(i)
>  		seq_printf(p, "CPU%-8d", i);
>  	seq_putc(p, '\n');
>  
>  	for (i = 0; i < NR_SOFTIRQS; i++) {
>  		seq_printf(p, "%12s:", softirq_to_name[i]);
> -		for_each_possible_cpu(j)
> +		for_each_online_cpu(j)
>  			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
>  		seq_putc(p, '\n');
>  	}


