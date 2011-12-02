Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab1LBRxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1LBRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:53:07 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=2V5AbZjj6MYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=97KaifJI1eutgnhyG9QA:9 a=Oykhxrnvj7BIe1kBjwwA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 0/2] (Was: Q: tracing: can we change
 trace_signal_generate() signature?)
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20111122205239.GA20971@redhat.com>
References: <20111121191920.GA24883@redhat.com>
	 <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com>
	 <1321912356.20742.24.camel@frodo>  <20111122205239.GA20971@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 12:53:05 -0500
Message-ID: <1322848385.30977.50.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 21:52 +0100, Oleg Nesterov wrote:
> O
> > Is "result" used for anything but tracepoints? When tracing is disabled,
> > the tracepoints should be just nops (when jump_label is enabled). Thus
> > tracing is very light. But if we are constantly calculating "result",
> > this is unused by those that don't use the tracing infrastructure, which
> > is 99.99% of all users. This is what I meant.
> 
> Ah I see. I thought you dislike OVERFLOW_FAIL/LOSE_INFO namely.
> 
> Of course, you are right. OTOH, this patch shaves 1058 bytes from
> .text. And without CONFIG_TRACE* gcc doesn't generate the extra code.

I was just noting that when tracing is disabled (CONFIG_TRACE* is set,
like it is on distros, but tracing is not happening), that we have extra
code. We usually strive to have tracing configured into the kernel, but
produces no (actually as little as possible) overhead when not actively
tracing.

That said, you know this code much more than I do. If this isn't a fast
path, and spinning a few more CPU cycles and perhaps dirtying a few
cache lines floats your boat. I'm OK with this change.

> 
> 
> 
> Oh. I simply do not know what can I do. Obviously, I'd like to avoid
> the new tracepoints in __send_signal(), imho this would be ugly. But
> the users want more info.
> 
> OK. let me send the patch at least for review. May be someone will
> nack it authoritatively, in this case I can relax and forward the
> nack back to bugzilla ;)

Again, if you don't think adding very slight overhead to this path is an
issue. Go ahead and add it.

> 
> However, at least 2/2 looks very reasonable to me. In fact it looks
> almost like the bug-fix.

2/2 looks to have the extra overhead to. Is the bug fix just with the
trace point.

Again, if you don't mind the overhead, then here:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


