Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0HAXwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:52:25 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50869 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0HAXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:52:24 -0400
Message-ID: <4C56089B.9090405@ncos.nec.co.jp>
Date: Mon, 02 Aug 2010 08:51:55 +0900
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: dave@gnu.org
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix /proc/softirqs file formatting
References: <1280516809.1955.0.camel@cowboy>
In-Reply-To: <1280516809.1955.0.camel@cowboy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/07/31 4:06), Davidlohr Bueso wrote:
> Hi,
> 
> The length of the BLOCK_IPOLL string is making it's value be printed too
> far to the right. This patch fixes this and makes the output a bit
> neater.
> 
> Currently:
>                 CPU0
>       HI:          0
>    TIMER:     599792
>   NET_TX:          2
>   NET_RX:          6
>    BLOCK:      80807
> BLOCK_IOPOLL:          0
>  TASKLET:      20012
>    SCHED:          0
>  HRTIMER:         63
>      RCU:     619279
> 
> With patch:
>                     CPU0
>           HI:          0
>        TIMER:     585582
>       NET_TX:          2
>       NET_RX:          6
>        BLOCK:      80320
> BLOCK_IOPOLL:          0
>      TASKLET:      19287
>        SCHED:          0
>      HRTIMER:         62
>          RCU:     604441
> 
> 
> 
> Thanks,
> Davidlohr
>  
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/proc/softirqs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
> index 1807c24..3799473 100644
> --- a/fs/proc/softirqs.c
> +++ b/fs/proc/softirqs.c
> @@ -10,13 +10,13 @@ static int show_softirqs(struct seq_file *p, void *v)
>  {
>  	int i, j;
>  
> -	seq_printf(p, "                ");
> +	seq_printf(p, "                    ");
>  	for_each_possible_cpu(i)
>  		seq_printf(p, "CPU%-8d", i);
>  	seq_printf(p, "\n");
>  
>  	for (i = 0; i < NR_SOFTIRQS; i++) {
> -		seq_printf(p, "%8s:", softirq_to_name[i]);
> +		seq_printf(p, "%12s:", softirq_to_name[i]);
>  		for_each_possible_cpu(j)
>  			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
>  		seq_printf(p, "\n");

Sorry for late response.

It looks good to me.

// Keika Kobayashi
