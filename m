Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1GENR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:17:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:39571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab1GENRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:17:55 -0400
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110705131005.GA5843@elte.hu>
References: <20110705100320.GK17941@sun> <20110705102017.GA12458@elte.hu>
	 <20110705103403.GN17941@sun> <20110705105959.GA14435@elte.hu>
	 <20110705110550.GQ17941@sun> <20110705112002.GA15654@elte.hu>
	 <20110705113620.GS17941@sun> <20110705114437.GC15654@elte.hu>
	 <20110705114944.GT17941@sun> <20110705121421.GU17941@sun>
	 <20110705131005.GA5843@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 15:17:21 +0200
Message-ID: <1309871841.3282.148.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 15:10 +0200, Ingo Molnar wrote:
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > perf, x86: P4 PMU - Add hw_watchdog_set_attr helper to simulate cpu-cycles counting in nmi-watchdog
> > 
> > Because of constraints existed in Netburst PMU counting
> > cpu cycles is allowed for one consumer only.
> > 
> > If the kernel is booted up with nmi-watchdog enabled
> > the watchdog become a consumer of such event and there
> > is no more room left for "perf top" and friends (ie any
> > attempts to count cpu cycles simultaneously with nmi-watchdog
> > doomed to fail).
> 
> Hm, what is the symptom - 'perf top' reports nothing?
> 
> If multiple users request cycles then perf will time-share them - 
> this is what happens if you run many 'perf top' or 'perf stat' 
> sessions in parallel for example. For example i just tried to run six 
> separate 'perf top' in parallel - and all six worked fine.
> 
> So the question is, why does the NMI watchdog prevent 'perf top' from 
> working on a P4?

because the NMI watchdog is a pinned event, you don't want to share the
counter, that would be very bad, suppose you lock up when the NMI
watchdog was scheduled out. Unreliably debug tools are worse than no
tools.
