Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab2HPVNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:13:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab2HPVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:13:37 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=07ZCQtT27sEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZRzJ3tYFNvQA:10 a=meVymXHHAAAA:8 a=8mR9c8h7AAAA:8 a=gu6fZOg2AAAA:8 a=SUCv1k2fOs69BkYCsPsA:9 a=PUjeQqilurYA:10 a=LdTqRQehjdcA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345151613.3708.4.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 16 Aug 2012 17:13:33 -0400
In-Reply-To: <20120816205539.GA16308@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <20120816141253.0142ddd0@lwn.net>
	 <20120816205539.GA16308@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 22:55 +0200, Borislav Petkov wrote:
> Hi Jon,
> 
> On Thu, Aug 16, 2012 at 02:12:53PM -0600, Jonathan Corbet wrote:
> > On Thu, 16 Aug 2012 19:45:19 +0200
> > Borislav Petkov <bp@amd64.org> wrote:
> > 
> > > off and on I get some free time to work on that, here's the latest
> > > incarnation. It contains review feedback from the earlier round.
> > 
> > Can I add one small request for the next round?  I've looked through the
> > patches and the code a bit, and I still have absolutely no clue of what a
> > "persistent event" is or why I might want one.  Now, admittedly, I'm
> > slower than most, but it still might not hurt to add some overall
> > description of what this is for...?
> 
> yeah, maybe the naming is not the most fitting one but here's the basic
> idea:
> 
> Normally, you enable perf events for a duration of time where you trace
> your workload and then you disable them. In contrast, persistent events
> are perf events which you enable at system boot and they remain enabled
> - thus persistent - during the whole system lifetime.
> 
> The machinery logs all events and carries them out to userspace. Much
> like the blackbox of a plane which records system events during the
> whole flight.
> 
> And the usecase here is that we want the machine check code to log
> machine checks during the whole system lifetime using the perf/trace
> events infrastructure. And this happens regardless of whether there's a
> userspace consumer of the logged data. Normally, we'll have one though
> :).
> 
> MCA and the trace_mce_record() tracepoint is thus is the first user of
> the persistent events but there might be others.
> 
> Please follow this thread:
> http://marc.info/?l=linux-kernel&m=133234057614885 for some more
> thoughts on the idea.
> 
> Of course, this whole thing is basically a rough draft and we're still
> hammering out the details as we go.

BTW, we already have a persistent buffering in the kernel. It's used by
ftrace. What about having perf use that buffering for persistent events?
Or is there some other issues about using it.

I'm currently working on having perf read ftrace data, so in the near
future, I plan on having some RFC patches to have perf reading from this
buffer anyway.

-- Steve


