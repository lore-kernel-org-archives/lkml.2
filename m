Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1DHHiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:38:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab1DHHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:38:01 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=-Ykyf7MhCaYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=b1jkkJeCZt-L41cwu1MA:9 a=yLG284o8V09eru26JCoA:7 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110408002812.GG1798@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
	 <20110407013349.GH1867@nowhere>
	 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
	 <20110407120608.GB1798@nowhere>
	 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
	 <20110407213208.GE1798@nowhere>
	 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
	 <20110408002812.GG1798@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 03:37:48 -0400
Message-ID: <1302248268.21026.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 02:28 +0200, Frederic Weisbecker wrote:

> > This is all very interesting, but doesn't really help us. I'd prefer
> > to focus on the proposal itself than discuss the merits of perf and
> > ftrace. We're using ftrace for the foreseeable future, and afaik, it's
> > still a maintained part of the kernel. If perf improves its
> > performance for tracing, then we can consider switching to it. We
> > could invest time improving perf, and that might be worthwhile, but
> > ftrace is here now.
> 
> You are investing upstream for your tracing needs. And that's really
> a nice step that I appreciate, as IIRC, Google had its own internal tracing
> (ktrace?) before. Nonetheless you can't be such a significant
> user/developer of the upstream kernel tracing and at the same time ignore some
> key problems of the actual big picture of it.
> 
> You need to be aware that we are not going anywhere if we duplicate
> every features between perf and ftrace. We want to merge the common
> pieces, keep the best of them and not expand the two tier tracing of today.


I agree that it would be great if we can start to merge the two. But
until we have a road map that we can all agree upon, I don't see that
happening in the near future. But I may be wrong ;)

> 
> I wish people stop thinking about perf and ftrace as
> competitors.

I don't think this is about perf and ftrace as competitors, but they are
currently two different infrastructures that are existing in the kernel.
They are currently optimized for different purposes. ftrace is optimized
for system tracing (persistent buffers and such) where as perf is
optimized for user tracing. But the two can do both but the other
feature is not as efficient as the other tool.

As you said perf has a lot of overhead due to data that it saves per
event. How easy is it to modify that without breaking the ABI?

>  Probably developers could start having a sane view
> once both will have close performances and then we can start
> thinking about a common backend (a buffer abstraction, which development
> can be iterated incrementally, usable with a syscall) and eliminate the
> overlapping pieces.

I wouldn't say eliminate, but at least merge the overlapping pieces. I'm
still totally against stripping out the debugfs code, and as tools have
been made to depend on it, I'm not sure we can rip it out. But I do not
see any harm in supporting both a debugfs feature along with a syscall
interface. I'm willing to do the leg work here to keep it.

> 
> I'm not asking you to unify the kernel tracing all alone. But you need to
> start to enlarge your view.

You might want to be a bit more specific by what you mean here.
 
> 
> I tend to think perf is more suitable for finegrained context definition
> in general.

I actually agree, as perf is more focused on per process (or group) than
ftrace. But that said, I guess the issue is also, if they have a simple
solution that is not invasive and suits their needs, what's the harm in
accepting it?

-- Steve


