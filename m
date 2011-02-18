Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab1BRUbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:31:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60967 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab1BRUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=kew3ncDC27LK0/hkU5ZlIlcKHgu7BKarBXuT6jMwNnk3tnHtLEHCLrlUtr1c26J6pw
         kiRDLWrx/5sKT8xd8WVwSzCm6OnDNwTjjVnRs9VhArQvPi+f+ONYdx7HYE4dOQ64Bq1a
         OAn7bUplhd1NsG/bt0714o0nozne+6XGbmt2I=
Date: Fri, 18 Feb 2011 18:30:15 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
Message-ID: <20110218203015.GF302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-4-git-send-email-daahern@cisco.com>
 <20110218070657.GA11404@elte.hu>
 <4D5E8204.2090501@cisco.com>
 <20110218175926.GA3445@nowhere>
 <20110218184119.GC302@ghostprotocols.net>
 <20110218192953.GB5658@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218192953.GB5658@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 18, 2011 at 08:29:56PM +0100, Frederic Weisbecker escreveu:
> On Fri, Feb 18, 2011 at 04:41:19PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Feb 18, 2011 at 06:59:30PM +0100, Frederic Weisbecker escreveu:
> > > The timestamps will be the cpu time and not the walltime, but at least that seems
> > > to be partly what you seek?
> > 
> > The whole issue for him, AFAIK, is to correlate perf events with app
> > events.
> > 
> > Think about tcpdump + networking tracepoints or 'perf probe' dynamic
> > events in the network stack, he wants to merge those logs and correlate
> > the tcpdump packet exchange with the tracepoints events in the network
> > stack, etc.
> > 
> > I.e. it doesn't matter if it is ftrace or not, having a common clock
> > shared between apps and kernel tracing/whatever infrastructure is what
> > David is after, right?
> > 
> > He can change userspace to use the clock the kernel is using in the
> > perf/ftrace/whatever infrastructure or make the kernel use the clock
> > userspace uses.
> > 
> > The issue here is who will bend, u or k ;-)
> 
> Right. I don't disagree with the need of a walltime. That already
> in debate :)
> 
> I was rather arguing about the tracing part. Adding support in perf report
> in the wrong way to do this. If something must be extended, It should be done
> in perf script, where we do the tracing support.

Squashing "profiling" and "tracing" differences is something I think
worthy.

Its all about events, that should be treated as equal in all tools. So I
don't think 'perf script' is about tracing, its about handling events
found in the event stream, be it hw, sw, tracepoints, dynamic probes put
in place by 'perf probe', or whatever event source we end up having.

A 'clock_gettime' like event, sampling whatever POSIX clock the kernel
supports should be enough flexibility, leaving concerns about sanity of
any particular use to the rope user.

Of course, extensibility via 'perf script' or 'use perf' in perf scripts
should provide great avenues for experimentation, not requiring changes
in the builtins :-)

- Arnaldo
