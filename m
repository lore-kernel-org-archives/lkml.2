Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2ETJCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 05:02:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2ETJBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 05:01:33 -0400
Message-ID: <4FB8B2E6.5010601@onlinehome.de>
Date: Sun, 20 May 2012 11:01:26 +0200
From: Martin <marogge@onlinehome.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BFS 420: cleanup in tick handling
References: <j2MgV-2Qe-9@gated-at.bofh.it>
In-Reply-To: <j2MgV-2Qe-9@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:qDh6zhhXv4RUpJkrfmqlps4iE8kfxhD7W6cGBczzGZN
 QfUivhy3fV7biwhh+RkIfR/2yl+nhEryAvF2hcBjTBmHLebXpp
 Y0HyQZqUCzp+1jeFK00qrjk9f5SfJcD2r+bbkyWWUcHIbZPJJh
 x9SfbG0ZoJXw6IPKWMvjoyYXe2OmG8vZZCXpTYue0ULdygoFxh
 +vvbvmUT4d9ER+CZ4wHXZ/uFBcuw+fUo11rR12Y4leTlshd/Bt
 DUFI/s+VR7iJ3w+ta5lIX3xyKc5ZtnQINnLersKhoLajWvY1fb
 viwonmaWG/EpX4QrVsGhc3EeF1f+PewA329pzG4RdwdBY9yiIX
 /Nha5b9IeY0dpYgAq234=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 09:30 AM, Hillf Danton wrote:
> The cpu on stack is not needed, so remove it.
>
> --- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
> +++ b/kernel/sched/bfs.c	Sat May 19 15:18:24 2012
> @@ -2822,8 +2822,7 @@ void wake_up_idle_cpu(int cpu);
>    */
>   void scheduler_tick(void)
>   {
> -	int cpu __maybe_unused = smp_processor_id();
> -	struct rq *rq = cpu_rq(cpu);
> +	struct rq *rq = this_rq();
>
>   	sched_clock_tick();
>   	/* grq lock not grabbed, so only update rq clock */
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hillf, I noticed you posting a few patches to BFS recently. Just wanted 
to make you aware that there is a certain erm communication issue 
between the kernel maintainers and the author of BFS. Since he is busy 
in real life you should contact him directly or cc him. See tail -1 
Documentation/scheduler/sched-BFS.txt for email.
