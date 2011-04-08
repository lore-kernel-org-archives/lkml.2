Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab1DHU1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:27:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab1DHU1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wuZ42x5WxNe/ErBhiw3P69MX1VfhRMrIwB3mvM/KrMma/Xmzw5sgvF32vTa2tPvGjE
         MUx2VD0DrfVgJGzL0CZQ==
MIME-Version: 1.0
In-Reply-To: <BANLkTikOi1Y_5RH1juPmchWHjW8f=ynuRA@mail.gmail.com>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
 <20110407013349.GH1867@nowhere> <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
 <20110407120608.GB1798@nowhere> <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
 <20110407213208.GE1798@nowhere> <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
 <20110408002812.GG1798@nowhere> <1302248268.21026.18.camel@frodo>
 <20110408134537.GA1967@nowhere> <1302271672.9086.155.camel@twins> <BANLkTikOi1Y_5RH1juPmchWHjW8f=ynuRA@mail.gmail.com>
From: Justin TerAvest <teravest@google.com>
Date: Fri, 8 Apr 2011 13:27:00 -0700
Message-ID: <BANLkTin-05pi94_qDw8Qkn2jCpv_V9j6sw@mail.gmail.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
To: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 11:32 AM, Michael Rubin <mrubin@google.com> wrote:
> Minor history, Google wrote ktrace which we started to push upstream
> and then jumped on the ftrace train. ftrace was a very good drop in
> replacement for us. ftrace has a lot of features ktrace did not. We
> use perf also in other contexts.
>
> We have devoted a lot of time and energy from many engineers outside
> of kernel to use ftrace. It's not just the kernel code, but we have
> built a lot of sw on ftrace as we examine systems in the cloud. It was
> not easy to make this migration since it had a lot of user impact. It
> was less the low level API but the fact that the tracepoints semantics
> had changed. Google is in the process of no longer using ktrace.
>
> Requirements for tracing for us seem to be:
> 1) Around 250ns latencies when enabled

It's worth pointing out that this is a goal for us on ftrace.

We were able to do this well with ktrace, and have devoted effort to
making ftrace faster, but we're not at 250ns yet. We know that is
where we want to be.

> 2) Small events - We have worked on shrinking the ftrace event size.
> Since we are constrained on the amount of memory we can use in the
> ring buffer, every byte counts. A nice sized event is on the order of
> <= 8 bytes. Some of the 2.6.34 ftrace events like irq_enter and exit
> were too big around 20 bytes. sched_switch is around 60 bytes.
>
> I am not sure that perf meets these requirements. We need to use
> ftrace for tracing _now_.  Google also needs to focus on improving
> ftrace upstream so we can contribute our changes to the community. We
> are submitting patches and working with upstream to improve ftrace.
> Currently we depend on ftrace and being around for a long time.
>
> Fredric wrote:" Nonetheless you can't be such a significant
> user/developer of the upstream kernel tracing and at the same time
> ignore some key problems of the actual big picture of it."
>
> I see less of a big picture issue and more of an awkward two pictures.
> From my view it's a question of whether ftrace should continue to be
> supported and improved or whether perf will do everything as well and
> when. We depend on ftrace today and as such we have invested our time
> there.
>
> mrubin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
