Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0IXQv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:51:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0IXQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:51:04 -0400
X-Authority-Analysis: v=1.1 cv=SIisYguqrHWpoArGjTKgRBrwMsv1JGTstWP6W6HZp+Y= c=1 sm=0 a=g-qrq3tmAnAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=qPiaywthkWxmue9H9LwA:9 a=xXTF78B-1CtVRBF0ImV1Fg8PGYEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: latency tracing in mainline or rt
From: Steven Rostedt <rostedt@goodmis.org>
To: Jack Daniel <wanders.thirst@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Jiri Olsa <jolsa@redhat.com>,
        fweisbec@gmail.com
In-Reply-To: <AANLkTikjk-Wqz-dAi4Ozy=PSL7n1-sfrRhrP6GwjavA3@mail.gmail.com>
References: <AANLkTikjk-Wqz-dAi4Ozy=PSL7n1-sfrRhrP6GwjavA3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 24 Sep 2010 12:26:49 -0400
Message-ID: <1285345609.31083.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 21:44 +0530, Jack Daniel wrote:
> Hi,
> 
> Can some one tell me the difference between Latency tracing that's
> here http://people.redhat.com/mingo/latency-tracing-patches/ and the
> tracing supported in the RT kernel here
> http://www.kernel.org/pub/linux/kernel/projects/rt/ ? What's the
> status of the present latency tracing and its documentation. Does
> Ftrace override these with its superior tracing? Any help is highly
> appreciated.

Ftrace was derived from two projects. One was my own logdev, and the
other was Ingo's latency tracing patches. The irq/preempt off tracers
still hold some of the code from the latency tracing patches practically
untouched.

With the old latency tracing patches, to enable or disable the tracing
feature, you had to change a config option and recompile the kernel.

With ftrace, you only need to 

  echo irqsoff > /sys/kernel/debug/current_tracer

to enable irqsoff tracing (the latency of the kernel where it disables
interrupts).

Please read the documentation in the kernel source
Documentation/trace/ftrace.txt.

To answer your questions, ftrace is really just latency-tracing next
generation ;-)

-- Steve


