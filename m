Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1FXVDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:03:50 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:38772 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1FXVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:03:49 -0400
Date: Fri, 24 Jun 2011 17:03:39 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: perf: is PERF_COUNT_SW_CONTEXT_SWITCHES a kernel or user event?
Message-ID: <alpine.DEB.2.00.1106241658420.23095@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

the commit included in 2.6.34:
  perf: Use hot regs with software sched switch/migrate events
  e49a5bd38159dfb1928fd25b173bc9de4bbadb21

Changes the behavior of the PERF_COUNT_SW_CONTEXT_SWITCHES
counter.

Before 2.6.34 all of the PERF_COUNT_SW_CONTEXT_SWITCHES events were 
counted as happening in userspace (they show up in "perf stat -e cs:u") 
but after the commit they always happen in kernelspace ("perf stat -e 
cs:k").

Was this intended behavior?
I'm writing a validation test for this and want to make sure I get it
right.

This can be confusing if your tool defaults to userspace only counts (PAPI 
does this).

Thanks,

Vince
