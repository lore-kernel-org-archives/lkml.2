Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1CAQNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:13:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36750 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab1CAQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:13:30 -0500
MIME-Version: 1.0
Date: Tue, 1 Mar 2011 17:05:55 +0100
Message-ID: <AANLkTinbYWQxde2jTcAtyYQGvGgt2Lmtnph=voj=haXF@mail.gmail.com>
Subject: [PATCH V6 0/2] tracing, perf: cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds some tracepoints for tracing cpu state and for
profiling the plug and unplug sequence.

Some SMP arm platform uses cpu hotplug feature for improving their
power saving because they can go into their deepest idle state only in
mono core mode. In addition, running into mono core mode makes the
cpuidle job easier and more efficient which also results in the
improvement of power saving of some use cases. As the plug state of a
cpu can impact the cpuidle behavior, it's interesting to trace this
state and to correlate it with cpuidle traces.
Then, cpu hotplug is known to be an expensive operation which also
takes a variable time depending of other processes' activity (from
hundreds ms up to few seconds). These traces have shown that the arch
part stays almost constant on arm platform whatever the cpu load is,
whereas the plug duration increases.

---
 include/trace/events/cpu_hotplug.h |  103 ++++++++++++++++++++++++++++++++++++
 kernel/cpu.c                       |   18 ++++++
 2 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/cpu_hotplug.h
