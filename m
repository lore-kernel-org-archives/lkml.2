Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1LTKsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:48:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1LTKsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:48:02 -0500
Message-ID: <1324378070.24621.32.camel@twins>
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 11:47:50 +0100
In-Reply-To: <20111220103154.GA1861@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>
	 <20111220103154.GA1861@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 11:31 +0100, Jiri Olsa wrote:
> On Fri, Dec 16, 2011 at 03:03:16PM +0100, Peter Zijlstra wrote:
> > On Fri, 2011-12-16 at 15:02 +0100, Peter Zijlstra wrote:
> > > > event_tracepoint:       PE_NAME_TP ':' PE_NAME_TP modifier
> > > > event_raw:              PE_SEP_RAW PE_VALUE modifier
> > > > event_numeric:          PE_VALUE ':' PE_VALUE modifier
> > > > event_symbolic:         PE_NAME_SYM modifier
> > > > event_generic_hw:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier |
> > > >                         PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier |
> > > >                         PE_NAME_CACHE_TYPE modifier
> > > > event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> > > > event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> > > > modifier:               PE_MODIFIER_EVENT | empty
> > > 
> > > This isn't complete, we need means of specifying
> > > perf_event_attr::config[12] when specifying a raw event. 
> > 
> > Also, it might make sense to think about how to specify sysfs events
> > (which don't exist yet).
> 
> any idea/details/specifics how they might look like? ;)

The current idea is that they'd live in a place like:

  /sys/bus/event_source/devices/$pmu/events/$event

and when you read them they contain a full event_raw style string so you
could do things like:

  perf record -e `cat $sysfsfile` or so

(or maybe without the 'r' prefix).

The idea was to have some $pmu:$event like syntax, but seeing that ':'
is already used quite a lot, there's maybe a more suitable separator.
Maybe '/' would do, yielding things like cpu/instructions.

Then again, it might make sense to restructure the syntax without
considerations for the status quo and see if we can come up with
something a little more consistent, the above event_* things are quite a
hodge podge, syntax wise.

While I appreciate that they are the result of organic growth, it
doesn't mean we shouldn't try and restructure stuff once in a while when
it makes sense.
