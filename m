Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0KJOpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:45:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:9419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0KJOpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:45:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,178,1288594800"; 
   d="scan'208";a="572118159"
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289391709.2191.102.camel@laptop>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
	 <1289391709.2191.102.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 22:45:19 +0800
Message-Id: <1289400319.2479.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 20:21 +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> > Some hardware counters(for example, Intel RAPL) can't generate interrupt
> > when overflow. So we need to simulate the interrupt to periodically
> > record the counter values. Otherwise, the counter may overflow and the
> > wrong value is read.
> > 
> > This patch uses event group to simulate PMI as suggested by Peter
> > Zijlstra, http://marc.info/?l=linux-kernel&m=128220854801819&w=2
> > 
> > create_group_counters() will create a group with 2 events, one hrtimer
> > based event as the group leader, and the other event to count. The
> > hrtimer is fired periodically, so the sibling event can record its
> > counter value periodically as well.
> 
> I'm terribly confused here....
> 
>  - you introduce perf_event_attr:pmi_simulate, but then you never
> implement it -- nor do we need it afaict.

Someone need to simluate pmi will use it in future.

> 
> 
>  - you use grouped counters for perf-stat, perf-stat doesn't use
> sampling so I don't see a need to group events to simulate the PMI.
> 

Aha, sorry, actually, I mean to periodically read the PMI-less counter
and reset it to zero each time to avoid overflow.

Well, seems I have done this in the wrong way.
Let me re-think about it.


