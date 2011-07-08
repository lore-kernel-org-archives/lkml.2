Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1GHNBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:01:53 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43392 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1GHNBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:01:52 -0400
Date: Fri, 8 Jul 2011 17:01:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110708130147.GD23657@sun>
References: <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
 <1309876851.3282.235.camel@twins>
 <20110705145656.GA18116@elte.hu>
 <20110705152515.GE4060@sun>
 <20110708124906.GD4303@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708124906.GD4303@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:49:06PM +0200, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > > On P4 BUS_CYCLES would be able to co-exist with CPU_CYCLES so it 
> > > will solve the P4 issue naturally as well.
> > 
> > i don't think it changes much, Ingo, if I change it to bus cycles I 
> > still will have to setup nmi-watchdog event separately (but simply 
> > with bus event).
> 
> You did not understand my point, my suggestion is to change this in 
> kernel/watchdog.c:
> 
> static struct perf_event_attr wd_hw_attr = {
>         .type           = PERF_TYPE_HARDWARE,
>         .config         = PERF_COUNT_HW_CPU_CYCLES,
> 
> to:
> 
> static struct perf_event_attr wd_hw_attr = {
>         .type           = PERF_TYPE_HARDWARE,
>         .config         = PERF_COUNT_HW_BUS_CYCLES,
> 
> Thanks,
> 
> 	Ingo

Ah, I see. Ingo, if events alias patch I posted yesterday will do
the trick we will be able to simply drop all this hooks. So as
only Don (or someone) confirm the patch works I'll kill this mess.

Changing cpu-cycles to bus cycles will allow nmi-watchdog and
perf top co-exsist but it means perf bus-cycles won't work anymore
with active nmi-watchdog. So I think events aliases (again, if it
work :) will be better for us, right?

	Cyrill
