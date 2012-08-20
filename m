Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2HTINm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:13:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab2HTINh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:13:37 -0400
Message-ID: <5031F1B3.2040309@gmail.com>
Date: Mon, 20 Aug 2012 16:13:39 +0800
From: Charles Wang <0oo0.hust@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, dsmythies@telus.net,
        Charles Wang <muming.wq@taobao.com>,
        Charles Wang <muming.wq@gmail.com>
Subject: Re: [PATCH] sched: add missing call for calc_load_exit_idle
References: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
In-Reply-To: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No email address provided by Azat Khuzhin, so I don't know
how to let him know this. - -!

On 08/20/2012 04:02 PM, Charles Wang wrote:
>  From Charles Wang <muming.wq@taobao.com>
>
> Azat Khuzhin reported "high loadavg in linux-3.6"
>
> After checking for upstream's code, I found Peter's patch
> (Commit id:5167e8d5417bf5c322a703d2927daec727ea40dd) not be
> fully applied, missing the call for calc_load_exit_idle.
> After that idle exit in sampling window will always be calculated
>   to non-idle, and the load will be higher than normal.
>
> This patch add the missing call for calc_load_exit_idle.
>
> Signed-off-by: Charles Wang <muming.wq@taobao.com>
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 024540f..3a9e5d5 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -573,6 +573,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
>   	tick_do_update_jiffies64(now);
>   	update_cpu_load_nohz();
>
> +	calc_load_exit_idle();
>   	touch_softlockup_watchdog();
>   	/*
>   	 * Cancel the scheduled timer and restore the tick
>

