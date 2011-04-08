Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1DHOIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:08:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHOIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:08:42 -0400
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1302248268.21026.18.camel@frodo>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
	 <20110407013349.GH1867@nowhere>
	 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
	 <20110407120608.GB1798@nowhere>
	 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
	 <20110407213208.GE1798@nowhere>
	 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
	 <20110408002812.GG1798@nowhere>  <1302248268.21026.18.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 16:07:50 +0200
Message-ID: <1302271670.9086.154.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 03:37 -0400, Steven Rostedt wrote:
> I don't think this is about perf and ftrace as competitors, but they are
> currently two different infrastructures that are existing in the kernel.
> They are currently optimized for different purposes. ftrace is optimized
> for system tracing (persistent buffers and such) where as perf is
> optimized for user tracing. 

That's complete nonsense, perf isn't build for tracing at all, its just
that tracing is a special case of the larger problem set of
sampling/profiling it is build for.

Nor is perf in any way shape or form better suited for user than for
kernel space, it really doesn't care, if we'd only be interested in user
crap we'd never have done NMI sampling for instance.

> But the two can do both but the other
> feature is not as efficient as the other tool.

Well, neither can do user-space-tracing at all, simply because we don't
have hooks into userspace, although the uprobes stuff looks to cure some
of that.

> As you said perf has a lot of overhead due to data that it saves per
> event. 

Someday you should actually read the perf code before you say something.

