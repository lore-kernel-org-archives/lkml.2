Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0LVNqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:46:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0LVNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:46:31 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=fmvh2CNzynIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=txYTTjstOlMb3iaA6I4A:9 a=zWRaYogROfRHgaQ2llLd61FaNUwA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/core] tracing: Only trace sched_wakeup if it
 actually work something up
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1293023945.2170.121.camel@laptop>
References: <tip-14bc7a06c6175cfa8070a5f5022210b648c3e0a7@git.kernel.org>
	 <1293023945.2170.121.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 22 Dec 2010 08:46:27 -0500
Message-ID: <1293025587.22905.128.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 14:19 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 13:16 +0000, tip-bot for Steven Rostedt wrote:
> > Commit-ID:  14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> > Gitweb:     http://git.kernel.org/tip/14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> > Author:     Steven Rostedt <srostedt@redhat.com>
> > AuthorDate: Thu, 2 Dec 2010 16:56:14 -0500
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Fri, 3 Dec 2010 10:46:59 -0500
> > 
> > tracing: Only trace sched_wakeup if it actually work something up
> > 
> > Currently the tracepoint sched_wakeup traces the wakeup event even
> > if the wakeup failed to wake anything up. This is quite stupid
> > but it happens because we did not want to add a conditional
> > to the core kernel code that would just slow down the wakeup events.
> > 
> > This patch changes the wakeup tracepoints to use the
> > 
> >  DEFINE_EVENT_CONDITIONAL()
> > 
> > to test the "success" parameter and will only trace the event if
> > the wakeup was successfull.
> > 
> > The success field in the tracepoint is removed since it is no
> > longer needed.
> 
> I NAKed this, its stupid.

I wouldn't call it stupid, but unnecessary, yes.

Anyway, it was the last patch of the series.

Ingo, can you revert this last patch?

Thanks,

-- Steve



