Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab0EaFBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:01:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42165 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0EaFBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dHPArgYHccR5BzalePwhv4tbOVGgRDqvVIP0qx6QWpvAlszHnzKNSKczHVWJ7dTTj8
         orRz3DXksNkS+B1l0IMcKgZnQjg7EqCFdl/pY3chEqmIEeatVswu8MztFRCmpqHp5rP1
         ctKD94tWTayR3hwbtlpXawxxJX4aYm4S2TNao=
MIME-Version: 1.0
In-Reply-To: <20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	<AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	<20100528145329.7E2D.A69D9226@jp.fujitsu.com>
	<20100528125305.GE11364@uudg.org>
	<20100528140623.GA11041@barrios-desktop>
	<20100528143617.GF11364@uudg.org>
	<20100528151249.GB12035@barrios-desktop>
	<20100528152842.GH11364@uudg.org>
	<20100528154549.GC12035@barrios-desktop>
	<20100528164826.GJ11364@uudg.org>
	<20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 31 May 2010 14:01:03 +0900
Message-ID: <AANLkTikFk_HnZWPG0s_VrRkro2rruEc8OBX5KfKp_QdX@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Mon, May 31, 2010 at 9:21 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 28 May 2010 13:48:26 -0300
> "Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:
>>
>> oom-killer: give the dying task rt priority (v3)
>>
>> Give the dying task RT priority so that it can be scheduled quickly and die,
>> freeing needed memory.
>>
>> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 84bbba2..2b0204f 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -266,6 +266,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints)
>>   */
>>  static void __oom_kill_task(struct task_struct *p, int verbose)
>>  {
>> +     struct sched_param param;
>> +
>>       if (is_global_init(p)) {
>>               WARN_ON(1);
>>               printk(KERN_WARNING "tried to kill init!\n");
>> @@ -288,6 +290,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>>        * exit() and clear out its resources quickly...
>>        */
>>       p->time_slice = HZ;
>> +     param.sched_priority = MAX_RT_PRIO-10;
>> +     sched_setscheduler(p, SCHED_FIFO, &param);
>>       set_tsk_thread_flag(p, TIF_MEMDIE);
>>
>
> BTW, how about the other threads which share mm_struct ?

Could you elaborate your intention? :)

>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
