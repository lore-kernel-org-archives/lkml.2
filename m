Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1EXNfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:35:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab1EXNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:35:27 -0400
Subject: Re: [PATCH 3/3] perf_events: add Intel Sandy Bridge
 offcore_response low-level support (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTikQH-p1+j5vA30p1tae9aYcYD=eAA@mail.gmail.com>
References: <20110523161256.GA11624@quad> <1306167687.18455.22.camel@twins>
	 <BANLkTikQH-p1+j5vA30p1tae9aYcYD=eAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 15:38:46 +0200
Message-ID: <1306244326.2497.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 21:29 +0200, Stephane Eranian wrote:
> On Mon, May 23, 2011 at 6:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-05-23 at 18:12 +0200, Stephane Eranian wrote:
> >> This patch adds Intel Sandy Bridge offcore_response support by
> >> providing the low-level constraint table for those events.
> >>
> >> On Sandy Bridge, there are two offcore_response events. Each uses
> >> its own dedictated extra register. But those registers are NOT shared
> >> between sibling CPUs when HT is on unlike Nehalem/Westmere. They are
> >> always private to each CPU. But they still need to be controlled within
> >> an event group. All events within an event group must use the same
> >> value for the extra MSR. That's not controlled by the second patch in
> >> this series.
> >>
> >> Furthermore on Sandy Bridge, the offcore_response events have NO
> >> counter constraints contrary to what the official documentation
> >> indicates, so drop the events from the contraint table.
> >
> > You sending this suggests you actually have a SNB machine, do you also
> > happen to know how to use those SNB RSP MSRs? Lin Ming and I were
> > wondering how to fill out the extra-regs for
> > snb_hw_cache_events_jds[C(LL)].
> >
> You first need to describe what you want to measure with those generic
> events. Then, from that, we can try and find a match with the offcore_resp
> bits.

Dude, are you being obtuse on purpose or are you still not getting it?

Exact definitions don't matter, full stop. Pick a random 'exact'
definition of last-level-cache {access(hit+miss),miss} x
{read/write/prefetch} and generate the event that has strongest
correlation to it.

Failing that, explain how to interpret and use those SNB RSP bits and
I'll try, but as it stands the SDM isn't enough for me to even start to
understand how to use that register.

