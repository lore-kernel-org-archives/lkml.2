Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1LTP0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:26:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LTPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:25:56 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wmh8ChsIkccA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4S1qW6wH7CvvL9JZye0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324394753.5916.53.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 03/10] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Christoph Lameter <christoph@lameter.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 20 Dec 2011 10:25:53 -0500
In-Reply-To: <20111220145727.GB4393@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-4-git-send-email-jolsa@redhat.com>
	 <1324323335.5916.46.camel@gandalf.stny.rr.com>
	 <20111220145727.GB4393@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 15:57 +0100, Jiri Olsa wrote:

> > 
> > If the above is called with preemption enabled, it will not do what is
> > expected. We could disable function tracing on one CPU and then
> > re-enable it for another CPU even though it is already enabled.
> 
> It is only called inside perf reg callback within the
> schedule function where the preemption is disabled.
> 
> The ftrace_function_enable is called when task is scheduled in
> on respective cpu. Likewise the ftrace_function_disable is called 
> when task is scheduled out on respective cpu.

Yes I know how you use it, but this is an open API. It may be currently
only used by perf today, but that doesn't mean that it wont be used by
others. There's no documentation on how to use it. I don't look at this
and say, "oh this is used by perf, we only need to worry about how perf
uses it". That doesn't scale. It needs to be documented on how to use
it, and if it requires preemption disabled when calling it, it should
definitely be stated that fact and it may need a
WARN_ON(preempt_count()) or something.

-- Steve


