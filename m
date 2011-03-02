Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1CBVNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:13:11 -0500
Received: from www.tglx.de ([62.245.132.106]:46567 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab1CBVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:13:09 -0500
Date: Wed, 2 Mar 2011 22:12:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <AANLkTikqp9=w+2r+Swe_4O9v=MiD=1tjCGrOQc9grHxk@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103022201440.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <alpine.LFD.2.00.1102241900540.2701@localhost6.localdomain6> <AANLkTik1Aqt8qJ62h4k0PbLOU7qu3TtA=fWn=LJ6tQjc@mail.gmail.com> <alpine.LFD.2.00.1103021056460.2701@localhost6.localdomain6>
 <AANLkTikqp9=w+2r+Swe_4O9v=MiD=1tjCGrOQc9grHxk@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,

On Wed, 2 Mar 2011, Vincent Guittot wrote:
> On 2 March 2011 11:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 28 Feb 2011, Vincent Guittot wrote:
> >> The goal is to monitor the cpu hotplug activity and duration. I want
> >> to detect 2 kind of cpu_down/cpu_up call, ones which succeed to
> >> unplug/plug a core and ones which don't. But I'm not sure that we need
> >> to sort the failed calls into to the trace. We trace them because too
> >> much fails could point out a bug or a wrong use of cpu hotplug.
> >
> > This does not make sense at all. You want to see the failures, then
> > recording the error code makes even more sense. Your way of decoding
> > the error case by checking whether the next trace entry is there or
> > missing is just sloppy.
> >
> 
> The 1st goal was to focus on profiling and to make trace events as
> simple as possible but I agree that having all information is a better
> option. We can add a parameter in the trace which gets the return code
> or some test result like the value of cpu_hotplug_disabled.

That's neither a question of focus nor of better options.

The main point is correctness and usefulness. When we add new
facilities or infrastructure we want to make sure that they are
general useful and correct for all possible use cases we can imagine
at that point in time.

So yes, I understand your reasoning and your focus on your primary
interest, but I also want you to understand that this kind of review
has a very practical background (i.e. maintainability) and is not just
the annoying bullying people around conducted by grumpy old men.
 
Thanks,

	tglx
