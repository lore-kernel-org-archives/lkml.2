Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0KJMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:21:54 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34111 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab0KJMVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:21:51 -0500
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289369725.2430.39.camel@minggr.sh.intel.com>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 13:21:49 +0100
Message-ID: <1289391709.2191.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> Some hardware counters(for example, Intel RAPL) can't generate interrupt
> when overflow. So we need to simulate the interrupt to periodically
> record the counter values. Otherwise, the counter may overflow and the
> wrong value is read.
> 
> This patch uses event group to simulate PMI as suggested by Peter
> Zijlstra, http://marc.info/?l=linux-kernel&m=128220854801819&w=2
> 
> create_group_counters() will create a group with 2 events, one hrtimer
> based event as the group leader, and the other event to count. The
> hrtimer is fired periodically, so the sibling event can record its
> counter value periodically as well.

I'm terribly confused here....

 - you introduce perf_event_attr:pmi_simulate, but then you never
implement it -- nor do we need it afaict.


 - you use grouped counters for perf-stat, perf-stat doesn't use
sampling so I don't see a need to group events to simulate the PMI.


