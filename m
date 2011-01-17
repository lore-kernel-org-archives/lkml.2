Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1AQReB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:34:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1AQRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <20110117162105.GA1778@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
	<20110107151200.GB1736@nowhere>
	<AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
	<20110114183516.GB1926@nowhere>
	<AANLkTi=nugnkimG75Qh3t2vu8-qy2LKKHwoY2FFFpWDp@mail.gmail.com>
	<20110117162105.GA1778@nowhere>
Date: Mon, 17 Jan 2011 11:33:58 -0600
Message-ID: <AANLkTinob=u4BGpZgzgDKkYWZz=5S8wSfdoQvLSr=DRU@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 January 2011 10:21, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Jan 17, 2011 at 07:49:58AM -0600, Vincent Guittot wrote:
>> I was just wondering which tracepoints format between my 1st proposal
>> and yours was the easier to post process by an application like
>> pytimechart.
>
> No idea as pytimechart uses his own ad hoc event parsing. Either
> way there won't be much differences though.
>
>> I have updated the cpu hotplug tracepoint according to your remarks
>> and steve's ones. I have just replaced the second
>> cpu_arch_die_start/end in your proposal by cpu_arch_dead_start/endfrq
>
> Tracepoints tend to describe actions rather than states, although I can
> show you some exceptions as well. But this tends to be the major
> tendency. I suggest you to be stay consistent with this scheme.
>

For the cpu_die function which is called in the idle loop, we use
cpu_hotplug_arch_die_start/end
and for the __cpu_die function which waits for the cpu death, we could
use cpu_hotplug_arch_wait_death_start/end ?

as a summary we have :

cpu_hotplug_up_start/end
cpu_hotplug_down_start/end
cpu_hotplug_arch_up_start/end
cpu_hotplug_arch_disable_start/end
cpu_hotplug_arch_die_start/end
cpu_hotplug_arch_wait_death_start/end


> Thanks.
>
