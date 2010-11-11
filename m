Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0KKTiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:38:15 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1057 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754080Ab0KKTiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:38:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23307
Date: Thu, 11 Nov 2010 20:38:10 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101111193810.GB1564@arch.trippelsdorf.de>
References: <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal>
 <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com>
 <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net>
 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net>
 <20101111191556.GA1564@arch.trippelsdorf.de>
 <1289504111.21413.2.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289504111.21413.2.camel@maggy.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.11 at 12:35 -0700, Mike Galbraith wrote:
> On Thu, 2010-11-11 at 20:15 +0100, Markus Trippelsdorf wrote:
> 
> > Just to add some data; here are the results from my machine (AMD 4
> > cores) running a -j4 kernel build, while I browsed the web:
> > 
> > 1) perf sched record sleep 30
> > 
> > without:
> > total_wakeups: 44306
> > avg_wakeup_latency (ns): 36784
> > min_wakeup_latency (ns): 0
> > max_wakeup_latency (ns): 9378852
> > 
> > with:
> > total_wakeups: 43836
> > avg_wakeup_latency (ns): 67607
> > min_wakeup_latency (ns): 0
> > max_wakeup_latency (ns): 8983036
> > 
> > 2) perf record -a -e sched:sched_switch -e sched:sched_wakeup sleep 10
> > 
> > without:
> > total_wakeups: 13195
> > avg_wakeup_latency (ns): 48484
> > min_wakeup_latency (ns): 0
> > max_wakeup_latency (ns): 8722497
> > 
> > with:
> > total_wakeups: 14106
> > avg_wakeup_latency (ns): 92532
> > min_wakeup_latency (ns): 20
> > max_wakeup_latency (ns): 5642393
> > 
> > So the avg_wakeup_latency nearly doubled with your patch, while the
> > max_wakeup_latency is lowered by a good amount.
> 
> When you say with/without, does that mean enabled/disabled, or
> patched/virgin and/or cgroups/nocgroups?

Patched/virgin and nocgroups
-- 
Markus
