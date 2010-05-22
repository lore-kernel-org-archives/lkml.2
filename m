Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0EVTDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:03:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45995 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0EVTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:03:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [RFC PATCH 0/2] perf: persistent events prototype
Date: Sat, 22 May 2010 21:04:46 +0200
Message-Id: <1274555088-6292-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Hi,

here is my first stab at persistent events. And since it is a first one,
there's no special tricks but simply all subsystems which init before
perf and have declared static tracepoints, simply mark some of them as
persistent and perf enables them when inits.

I haven't tested this yet and will do so when I get to work next week
but I'm sending it out now so that I can get your thoughts on this and
whether this is an agreeable direction I'm taking.

Couple of yet unresolved issues I see with this:

* persistent events are enabled unconditionally on all cpus and while
this makes sense for MCEs tracing, do we still want to be flexible here
and supply a cpumask instead?

* what happens if there's no consumer for the traced data, the easiest
would be to do nothing and let it get truncated in the trace buffer with
newer data overwriting the oldest sample?

* what about other events, and most importantly, what about hw events
for which we take a PMU and want to make them persistent at the
same time and it so happens that after making a couple of events
persistent, we run out of PMUs and make the perf tool almost useless
since persistent events are hogging all the hardware resources?

* btw, perf and ftrace really need to get married :)

/me ducks now...

Thanks.
