Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2BONBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:01:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:40236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2BONBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:01:00 -0500
Message-ID: <1329310854.2293.79.camel@twins>
Subject: Re: Question about resetting a sampling counter in kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: heechul Yun <heechul@illinois.edu>
Cc: linux-kernel@vger.kernel.org, Vince Weaver <vweaver1@eecs.utk.edu>
Date: Wed, 15 Feb 2012 14:00:54 +0100
In-Reply-To: <CAN_5kQB+BjPc5Sj=a-4B80-6t5D3C4WkvP6bz_BRcMd6LKAzqw@mail.gmail.com>
References: <CAN_5kQB+BjPc5Sj=a-4B80-6t5D3C4WkvP6bz_BRcMd6LKAzqw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-12 at 12:37 -0600, heechul Yun wrote:
> Hello,
> 
> I have a question about controlling performance counter in kernel.
> 
> I created a kernel counter which generates an interrupt at every
> 10000 cache-misses as shown below.
> 
> struct perf_event_attr sched_perf_hw_attr = {
>      .type = PERF_TYPE_HARDWARE,
>      .config = PERF_COUNT_HW_CACHE_MISSES,
>      .sample_period = 10000,
>      .size = sizeof(struct perf_event_attr),
>      .pinned = 1,
>      .disbled = 1,
> }
> 
> event = perf_event_create_kernel_counter(&sched_perf_hw_attr, cpu,
>        NULL, event_overflow_callback, NULL);
> 
> What I would like to do is to "reset" the counter before the
> overflow interrupt occurs (e.g, reset at 5000th event),
> and then to restart the sampling from 0.
> 
> I found perf_event_enable() and perf_event_disable() only
> start/stop the counting but couln't figure out how to reset the
> sampling as I described above.
> 
> I would be really thankful if you explain how I can efficiently reset the
> sampling counter.

Expose and use perf_event_reset().
