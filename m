Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0LJCde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:33:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61547 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LJCdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kUnCrdhLBQoZRNMWN/xbRrapsmPSdbyi52o/ZPOVpF6j3YbVBnB4+fNk+mBZ90xP04
         zjp3+RJ8q2BpE45qUlrIPvE5u3gxxMPVschDp6yyCITkFMze7HLPLnArJYOkHKfbejyw
         NMWXK2byLGAx3ziUVzIktHGRZvtXACkLzzvXo=
MIME-Version: 1.0
In-Reply-To: <1291908773.29292.16.camel@twins>
References: <1291802742.1417.9.camel@marge.simson.net>
	<tip-f26f9aff6aaf67e9a430d16c266f91b13a5bff64@git.kernel.org>
	<1291908773.29292.16.camel@twins>
Date: Fri, 10 Dec 2010 10:33:31 +0800
Message-ID: <AANLkTi=z3kQJfRqpA5iw91CWyGKnuAC1+qWdao_mS5+4@mail.gmail.com>
Subject: Re: [tip:sched/urgent] Sched: fix skip_clock_update optimization
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, bbb.lst@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 11:32 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-08 at 20:40 +0000, tip-bot for Mike Galbraith wrote:
>> @@ -4063,6 +4062,8 @@ need_resched_nonpreemptible:
>>
>>         put_prev_task(rq, prev);
>>         next = pick_next_task(rq);
>> +       clear_tsk_need_resched(prev);
>> +       rq->skip_clock_update = 0;
>>
>>         if (likely(prev != next)) {
>>                 sched_info_switch(prev, next);
>> @@ -4071,6 +4072,7 @@ need_resched_nonpreemptible:
>>                 rq->nr_switches++;
>>                 rq->curr = next;
>>                 ++*switch_count;
>> +               WARN_ON_ONCE(test_tsk_need_resched(next));
>
> I just managed to trigger this one.. will try and reproduce to find out
> wth happened.
>

I don't see it on my side.
Then just show some info(don't know if it's helpful):
wake_up_idle_cpu() can set TIF_RESCHED locklessly.

So does
WARN_ON_ONCE(next != rq->idle && test_tsk_need_resched(next));
help?

Thanks,
Yong


-- 
Only stand for myself.
