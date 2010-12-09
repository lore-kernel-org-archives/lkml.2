Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0LIPdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:33:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:34961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LIPdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:33:07 -0500
Subject: Re: [tip:sched/urgent] Sched: fix skip_clock_update optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, bbb.lst@gmail.com, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-f26f9aff6aaf67e9a430d16c266f91b13a5bff64@git.kernel.org>
References: <1291802742.1417.9.camel@marge.simson.net>
	 <tip-f26f9aff6aaf67e9a430d16c266f91b13a5bff64@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 16:32:53 +0100
Message-ID: <1291908773.29292.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 20:40 +0000, tip-bot for Mike Galbraith wrote:
> @@ -4063,6 +4062,8 @@ need_resched_nonpreemptible:
>  
>         put_prev_task(rq, prev);
>         next = pick_next_task(rq);
> +       clear_tsk_need_resched(prev);
> +       rq->skip_clock_update = 0;
>  
>         if (likely(prev != next)) {
>                 sched_info_switch(prev, next);
> @@ -4071,6 +4072,7 @@ need_resched_nonpreemptible:
>                 rq->nr_switches++;
>                 rq->curr = next;
>                 ++*switch_count;
> +               WARN_ON_ONCE(test_tsk_need_resched(next)); 

I just managed to trigger this one.. will try and reproduce to find out
wth happened.
