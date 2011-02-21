Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1BUVfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:35:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39903 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1BUVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=elAmBvwbFE1Ljxqlerg+NxwsbhfLYoi9Mi+AUikaYHZgdfhf+tDedy3qox44rdyHbA
         jdyaUn1Wr6Oc+JZuq3d9MeR7AjDNk9MtZaM0xIGFdpaRB1KJbj4QbNtmRtceFFdnDeBJ
         9A7R0vdT24EVQWk6Q185wA9r5FWLvHdRBKcts=
Date: Mon, 21 Feb 2011 22:17:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and
 report
Message-ID: <20110221211757.GB3583@nowhere>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-4-git-send-email-daahern@cisco.com>
 <20110218070657.GA11404@elte.hu>
 <4D5E8204.2090501@cisco.com>
 <20110218175926.GA3445@nowhere>
 <20110218184119.GC302@ghostprotocols.net>
 <20110218192953.GB5658@nowhere>
 <20110218203015.GF302@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218203015.GF302@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 06:30:15PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 18, 2011 at 08:29:56PM +0100, Frederic Weisbecker escreveu:
> > On Fri, Feb 18, 2011 at 04:41:19PM -0200, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Feb 18, 2011 at 06:59:30PM +0100, Frederic Weisbecker escreveu:
> > > > The timestamps will be the cpu time and not the walltime, but at least that seems
> > > > to be partly what you seek?
> > > 
> > > The whole issue for him, AFAIK, is to correlate perf events with app
> > > events.
> > > 
> > > Think about tcpdump + networking tracepoints or 'perf probe' dynamic
> > > events in the network stack, he wants to merge those logs and correlate
> > > the tcpdump packet exchange with the tracepoints events in the network
> > > stack, etc.
> > > 
> > > I.e. it doesn't matter if it is ftrace or not, having a common clock
> > > shared between apps and kernel tracing/whatever infrastructure is what
> > > David is after, right?
> > > 
> > > He can change userspace to use the clock the kernel is using in the
> > > perf/ftrace/whatever infrastructure or make the kernel use the clock
> > > userspace uses.
> > > 
> > > The issue here is who will bend, u or k ;-)
> > 
> > Right. I don't disagree with the need of a walltime. That already
> > in debate :)
> > 
> > I was rather arguing about the tracing part. Adding support in perf report
> > in the wrong way to do this. If something must be extended, It should be done
> > in perf script, where we do the tracing support.
> 
> Squashing "profiling" and "tracing" differences is something I think
> worthy.
> 
> Its all about events, that should be treated as equal in all tools. So I
> don't think 'perf script' is about tracing, its about handling events
> found in the event stream, be it hw, sw, tracepoints, dynamic probes put
> in place by 'perf probe', or whatever event source we end up having.
> 
> A 'clock_gettime' like event, sampling whatever POSIX clock the kernel
> supports should be enough flexibility, leaving concerns about sanity of
> any particular use to the rope user.
> 
> Of course, extensibility via 'perf script' or 'use perf' in perf scripts
> should provide great avenues for experimentation, not requiring changes
> in the builtins :-)

Right.

So I agree perf script should be tracing/profiling/any semantic agnostic.
But when it's about dumping, displaying events sequentially, it seems
an extension to perf script is a better place for that rather than
perf report. perf script default behaviour is already about displaying
raw traces. If support is needed to print the ip of the event or the
stacktraces, it's very welcome!
