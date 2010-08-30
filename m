Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0H3TgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:36:03 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39801 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab0H3TgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:36:01 -0400
Date: Mon, 30 Aug 2010 20:35:58 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 3/5] perf: Add hrtimer code for PMI-less hardware
 counters
Message-ID: <20100830193558.GE24828@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
 <38d993baf1328403d9a1c4a2f012c4aa0e19feab.1283123521.git.matt@console-pimps.org>
 <1283172902.1820.897.camel@laptop>
 <20100830132744.GB24828@console-pimps.org>
 <1283177544.1820.992.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283177544.1820.992.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 04:12:24PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-08-30 at 14:27 +0100, Matt Fleming wrote:
> 
> > I'm lost. Is it possible to do this patch entirely in userspace? How do
> > we periodically sample the counters if it's not being done in the
> > kernel?
> 
> perf_event_attr leader = {
>  .type = PERF_TYPE_SOFTWARE,
>  .config = PERF_COUNT_SW_TASK_CLOCK,
>  .sample_period = xxx,
>  .sample_type = PERF_SAMPLE_READ|...,
>  .read_format = PERF_FORMAT_GROUP,
> };
> 
> perf_event_attr counter = {
>  .type = PERF_TYPE_HARDWARE,
>  .config = PERF_COUNT_HW_CPU_CYCLES,
> };
>  
> leader_fd = sys_perf_event_open(&leader, pid, cpu, 0, 0);
> counter_fd = sys_perf_event_open(&counter, pid, cpu, leader_fd, 0);
> 
> Which gives you a group of 2 events, one software timer that samples,
> one hardware counter that only counts.

Aha. OK, thanks! I'll respin this.
