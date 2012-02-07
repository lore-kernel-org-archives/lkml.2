Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2BGPKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:10:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:10:50 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=jUaAapoLYvUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ee0r05h1atCzgE1wUckA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120207145653.829892056@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 09:56:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to handle rcu_idle_exit() tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch set for what I plan on pushing out to handle
the tracepoints that are called from within rcu_idle_exit() sections.

The first patch is the tracepoint infrastructure,
the second is the changes in x86
the third is the changes in the cpuidle driver.

I see there's use cases in the arm arch, but as that is in flux, I'll
let the arm folks deal with those.

-- Steve


Steven Rostedt (3):
      tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections
      x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
      cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() section

----
 arch/x86/kernel/process.c  |   24 ++++++++++++------------
 drivers/cpuidle/cpuidle.c  |    8 ++++----
 include/linux/tracepoint.h |   20 ++++++++++++++++----
 3 files changed, 32 insertions(+), 20 deletions(-)

