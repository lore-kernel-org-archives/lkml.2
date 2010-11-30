Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0K3WoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:44:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40597 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0K3WoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:44:11 -0500
Subject: Re: perf: some questions about perf software events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
In-Reply-To: <m3oc9a520m.fsf@gmail.com>
References: <m3tyj73qev.fsf@gmail.com> <1290598906.2072.461.camel@laptop>
	 <m3oc9a520m.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 23:44:31 +0100
Message-ID: <1291157071.32004.1374.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-27 at 14:28 +0100, Franck Bui-Huu wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > On Wed, 2010-11-24 at 12:35 +0100, Franck Bui-Huu wrote:
> 
> [...]
> 
> >> That is for no 'contiguous' events, setting a sampling frequency doesn't
> >> really make sense since for example you could set a frequency to 1000 HZ
> >> for the software ALIGNMENT_FAULT event and never get any samplings or at
> >> least getting sampling but with a totally different rate. And the
> >> current code doesn't look to handle sample_freq anyway.
> >
> > All the freq bits are in the generic code, it re-computes the rate on
> > the timer-tick as well as on each event occurrence. 
> >
> > Freq driven sampling should work just fine with swevents.
> >
> 
> Yes, but how does it behave with ALIGNMENT_FAULTS for example ?
> 
> Such event may happen at a very disparate rate or it can even never
> happen at all.

Then of course we'll never make the freq target, again, software events
aren't special there.

> >
> >> Also I'm currently not seeing any real differences between cpu-clock and
> >> task-clock events. They both seem to count the time elapsed when the
> >> task is running on a CPU. Am I wrong ?
> >
> > No, Francis already noticed that, I probably wrecked it when I added the
> > multi-pmu stuff, its on my todo list to look at (Francis also handed me
> > a little patchlet), but I keep getting distracted with other stuff :/
> 
> OK.
> 
> Does it make sense to adjust the period for both of them ?
> 
> Also, when creating a task clock event, passing 'pid=-1' to
> sys_perf_event_open() doesn't really make sense, does it ?
> 
> Same with cpu clock and 'pid=n': whatever <n> value, the event measure
> the cpu wall time clock.
> 
> Perhaps proposing only one clock in the API and internally bind this
> clock to the cpu or task clock depending on pid or cpu parameters would
> have been better ?
> 

No, it actually makes sense to count both cpu and task clock on a task
(cpu clock basically being wall-time).


