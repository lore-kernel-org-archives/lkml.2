Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1GEPZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:25:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38242 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1GEPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:25:21 -0400
Date: Tue, 5 Jul 2011 19:25:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705152515.GE4060@sun>
References: <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
 <1309876851.3282.235.camel@twins>
 <20110705145656.GA18116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705145656.GA18116@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 04:56:56PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2011-07-05 at 15:31 +0200, Ingo Molnar wrote:
> > > So there's lots of options to fix/improve this more intelligently.
> > 
> > Sure, and I like the alternative encoding thing best, but doing 
> > that will take time, in the meantime this patch, which is 
> > relatively small (and easy to revert once we get something better 
> > going) does fix a problem for those few unfortunate souls still 
> > using P4 hardware.
> 
> Well, the BUS_CYCLES thing looks similarly straightforward and should 
> result in an even simpler patch.
>

nope, bus cycles count fsb driving which is not the same as execution unit
productions, so I fear it is not that reliable and i guess (note _guess_ here
since I can't prove it without hardware handy :) if cpus are stuck with endless
loop inside kernel we might miss such lockup (hard scenario, since there
will be activity on fsb anyway, but still).

> On P4 BUS_CYCLES would be able to co-exist with CPU_CYCLES so it will 
> solve the P4 issue naturally as well.
> 
> Thanks,
> 
> 	Ingo

i don't think it changes much, Ingo, if I change it to bus cycles I still
will have to setup nmi-watchdog event separately (but simply with bus
event).

so an only option is the aliases, i'll try to deal with it but no milestones

	Cyrill
