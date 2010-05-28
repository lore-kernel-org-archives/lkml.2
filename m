Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0E1Hw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:52:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49917 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0E1Hw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mHOAbKvuXnLBHAtn5f+Ubaar1ElrzwuutiU/RTvsNhJgecizVzlXXoeOlqSlR8xdj9
         XVw1chSTfxXqrdfL7YsS/IYyRXpJeYCbEkO4djvH1APqPAitFIHGBSO13JAQ0yctzGXL
         wlm1dNjp1aL7SnPc7TfwptuL6E+KG+oleyGNc=
MIME-Version: 1.0
In-Reply-To: <20100528145329.7E2D.A69D9226@jp.fujitsu.com>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	<AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	<20100528145329.7E2D.A69D9226@jp.fujitsu.com>
Date: Fri, 28 May 2010 16:52:23 +0900
Message-ID: <AANLkTinLN0ex0uvwA_tohv7MSLHv8i8Mcr96va1C4Md-@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 2:59 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> RT Task
>>
>> void non-RT-function()
>> {
>>    system call();
>>    buffer = malloc();
>>    memset(buffer);
>> }
>> /*
>>  * We make sure this function must be executed in some millisecond
>>  */
>> void RT-function()
>> {
>>    some calculation(); <- This doesn't have no dynamic characteristic
>> }
>> int main()
>> {
>>    non-RT-function();
>>    /* This function make sure RT-function cannot preempt by others */
>>    set_RT_max_high_priority();
>>    RT-function A();
>>    set_normal_priority();
>>    non-RT-function();
>> }
>>
>> We don't want realtime in whole function of the task. What we want is
>> just RT-function A.
>> Of course, current Linux cannot make perfectly sure RT-functionA can
>> not preempt by others.
>> That's because some interrupt or exception happen. But RT-function A
>> doesn't related to any dynamic characteristic. What can justify to
>> preempt RT-function A by other processes?
>
> As far as my observation, RT-function always have some syscall. because pure
> calculation doesn't need deterministic guarantee. But _if_ you are really
> using such priority design. I'm ok maximum NonRT priority instead maximum
> RT priority too.

Hmm. It's just example. but it would be not good exmaple.
Let's change it with this.

void RT-function()
{
     int result = some calculation(); <- This doesn't have no dynamic
characteristic
     *mmap_base = result; <-- mmap_base is mapped by GPIO device.
}

Could we allow preemption of this RT function due to other task's
memory pressure?
Of course, Linux is not Hard RT featured OS, I think. So I thinks it
is a policy problem.
If we think system memory pressure is more important than RT task and
we _all_ agree such policy, we can allow it.

But I don't hope it.

-- 
Kind regards,
Minchan Kim
