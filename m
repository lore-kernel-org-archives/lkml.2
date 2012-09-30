Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2I3MRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 08:17:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40123 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2I3MQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 08:16:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120930085455.GJ10383@mtj.dyndns.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
	<7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
	<20120930085455.GJ10383@mtj.dyndns.org>
Date: Sun, 30 Sep 2012 17:46:45 +0530
Message-ID: <CAKohpon2xQxSqeOCTb=noki=QUH=Cf9Aggsd_uAv34TNfyC0FA@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2012 14:24, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Sep 27, 2012 at 02:34:05PM +0530, Viresh Kumar wrote:
>> - A cpu has programmed a timer and is IDLE now.
>> - CPU gets into interrupt handler due to timer and queues a work. As the CPU is
>>   currently IDLE, we can queue this work to some other CPU.
>
> I'm still a bit confused, if the CPU is already running the IRQ
> handler, the CPU is not idle by definition.  What am I missing here?

Hi Tejun,

For the scheduler CPU is idle, if all below are true:
- current task is idle task
- nr_running == 0
- wake_list is empty

And during these conditions, there can be a timer running in background.
And when we reach its interrupt handler, then also these conditions hold true
and local cpu is idle.

--
Viresh
