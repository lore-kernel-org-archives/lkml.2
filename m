Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2APRWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:22:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2APRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <4F13EC3F.7050308@linux.vnet.ibm.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
	<1326302955.2442.174.camel@twins>
	<CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
	<1326353130.2442.177.camel@twins>
	<CADZ9YHiGjjGJjxKj4WKWydqAz0zxFwY5=LsYBKhEREuZm=bKpg@mail.gmail.com>
	<4F13D77B.9070103@linux.vnet.ibm.com>
	<CADZ9YHiNWddjLBGnvDO==Jpz9nQtPREmkFOX0P5ELOK2neW1=g@mail.gmail.com>
	<4F13EC3F.7050308@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 23:22:09 +0600
Message-ID: <CADZ9YHgZcuoZ4_az3taqv2GJ_5mLKLmyOAUz2ZnA3G1YMLi1_w@mail.gmail.com>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in ttwu_do_activate()?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 3:22 PM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> On 01/16/2012 04:27 PM, Rakib Mullick wrote:
>
>> On Mon, Jan 16, 2012 at 1:53 PM, Michael Wang
>
> I saw this is the way to enqueue wake_list:
>
> try_to_wake_up --> p->state = TASK_WAKING; --> ttwu_queue -->
> ttwu_queue_remote --> llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)
>
Yes, right and if the task needs to wakeup on a remote CPU, then it
follows an reschedule IPI. But, what I was missing that, I wasn't sure
whether task gets added to wake_list only from ttwu_queue_remote() or
not. Now, I've found that - it is and you are right rq->wake_list only
have TASK_WAKING state.

> BTW, I'm just start to learn scheduler, may be I'm wrong, let's find out
> the right answer :)
>
I think it's quite clear to me now. And you are learning scheduler
well at-least better than me :)

Thanks,
Rakib
