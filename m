Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab2BATDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:03:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58492 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2BATDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:03:34 -0500
Date: Wed, 1 Feb 2012 20:03:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120201190327.GI6731@somewhere.redhat.com>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
 <20120130101121.GB8924@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130101121.GB8924@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:11:21AM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Sun, 2012-01-29 at 17:32 +0100, Ingo Molnar wrote:
> > > * Andrew Steets <asteets@rgmadvisors.com> wrote:
> > > 
> > > > On 1/28/12 6:01 AM, Ingo Molnar wrote:
> > > > 
> > > > >> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to 
> > > > >> disable perf event counters.  Here is a demonstration 
> > > > >> program:
> > > > >
> > > > > btw., what's your usecase?
> > > > 
> > > > I'm trying to profile a small section of a long-running 
> > > > program.  I ran into trouble using call-graph recording 
> > > > and I thought this might be an alternative way of getting 
> > > > what I was after.
> > > 
> > > That usecase indeed makes sense. Peter, could we allow this 
> > > for privileged tasks, depending on the perf_paranoia 
> > > settings or such?
> > 
> > I really dislike it. The sane way around this would be to 
> > allow easy self-profiling instead of doing things arse about 
> > face like that.
> 
> So, what workflow are you suggesting to Andrew?
> 
> I guess we are also hurting from the lack of dwarf stack 
> backtrace decoding - that would allow the filtering by parent 
> function without modifying the code. I think Frederic had a 
> prototype working for 32-bit - any update on that?

I haven't touched that for a while. I would be glad if
somebody else could relay me on this work.

I think Jiri Olsa has been working on something about Dwarf cfi
unwinding with a different approach. Mine was about dumping chunks
of stack and regs and do the unwinding on post processing. I think
Jiri is doing the unwinding from the event overflow fast path.

> 
> Andrew could work that problem around right now by adding:
> 
>    -fno-omit-frame-pointer
> 
> to the build of the utility - that should activate -g and 
> perf-report's --parent filter should also work fine.
> 
> Thanks,
> 
> 	Ingo
