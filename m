Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2EaNQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:16:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34026 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2EaNQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
Date: Thu, 31 May 2012 20:16:09 +0700
Message-ID: <CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 7:15 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Thu, May 31, 2012 at 3:12 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> This is what happens with Greg's 3.3.7 + Con's bfs-420 + your
>> bfs-420-421 patches, any idea?
>>
>>  CC      kernel/sched/bfs.o
>> kernel/sched/bfs.c: In function 'try_preempt':
>> kernel/sched/bfs.c:1450:2: error: incompatible type for argument 2 of
>> 'cpumask_next_and'
>> include/linux/cpumask.h:192:5: note: expected 'const struct cpumask *'
>> but argument is of type 'cpumask_t'
>> kernel/sched/bfs.c:1450:2: error: incompatible type for argument 3 of
>> 'cpumask_next_and'
>> include/linux/cpumask.h:192:5: note: expected 'const struct cpumask *'
>> but argument is of type 'cpumask_t'
>> kernel/sched/bfs.c:1450:2: warning: left-hand operand of comma
>> expression has no effect
>> make[2]: *** [kernel/sched/bfs.o] Error 1
>> make[1]: *** [kernel/sched] Error 2
>> make: *** [kernel] Error 2
>>
>
> My bad, lets try the follwoing fix /hd
>
>
> --- a/kernel/sched/bfs.c        Wed May 30 21:04:10 2012
> +++ b/kernel/sched/bfs.c        Thu May 31 20:05:44 2012
> @@ -1447,7 +1447,7 @@ static void try_preempt(struct task_stru
>        highest_prio = p->prio;
>        latest_deadline = p->deadline;
>
> -       for_each_cpu_and(cpu, cpu_online_map, p->cpus_allowed) {
> +       for_each_cpu_and(cpu, cpu_online_mask, tsk_cpus_allowed(p)) {
>                struct rq *rq;
>                int rq_prio;
>
> --

Thanks a lot Hillf, it builds fine now but it won't boot. Some crappy
mobile phone picture here:
http://ompldr.org/vZTE1eQ/IMG_20120531_200543.jpg
