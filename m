Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1E0PXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:23:12 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:46796 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab1E0PXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:23:10 -0400
Message-ID: <4DDFC1D6.4010303@ti.com>
Date: Fri, 27 May 2011 20:53:02 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
References: <1306343335.21578.65.camel@twins>	<1306358128.21578.107.camel@twins>	<BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>	<1306405979.1200.63.camel@twins>	<1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>	<1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>	<20110526154508.GA13788@redhat.com> <1306425584.2497.81.camel@laptop>	<1306426148.2497.83.camel@laptop> <20110526170422.GA18413@redhat.com>	<1306430264.2497.88.camel@laptop> <1306430633.2497.91.camel@laptop>
In-Reply-To: <1306430633.2497.91.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On 5/26/2011 10:53 PM, Peter Zijlstra wrote:
> On Thu, 2011-05-26 at 19:17 +0200, Peter Zijlstra wrote:
>> On Thu, 2011-05-26 at 19:04 +0200, Oleg Nesterov wrote:
>>> On 05/26, Peter Zijlstra wrote:
>>>>
>>>> @@ -2636,7 +2636,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>>>>   		 * to spin on ->on_cpu if p is current, since that would
>>>>   		 * deadlock.
>>>>   		 */
>>>> -		if (p == current) {
>>>> +		if (cpu == smp_processor_id()) {
>>>> +			p->sched_contributes_to_load = 0;
>>>>   			ttwu_queue(p, cpu);
>>>
>>> Btw. I do not pretend I really understand se->vruntime, but in this
>>> case we are doing enqueue_task() without ->task_waking(), however we
>>> pass ENQUEUE_WAKING. Is it correct?
>>
>> No its not, that's the thing that I got wrong the first time and caused
>> these pauses.
>
> We'd end up with something like the below, which isn't too different
> from what I've now got queued.
>
> It has the extra cpu == smp_processor_id() check, but I'm not sure this
> whole case is worth the trouble. I could go stick some counters in to
> verify how often all this happens I guess.
>
Are you planning send version of this patch for stable .39
too ?

Regards
Santosh
