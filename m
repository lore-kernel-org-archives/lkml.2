Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0EFCfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:35:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60396 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0EFCfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:35:17 -0400
MIME-Version: 1.0
Date: Wed, 5 May 2010 19:35:14 -0700
Message-ID: <s2i8bb80c381005051935zd5334eeby28865e9fdb206e55@mail.gmail.com>
Subject: sched: arch_scale_freq_power (and other cpu_power / sched related 
	questions)
From: Mike Chan <mike@android.com>
To: a.p.zijlstra@chello.nl, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before I end up duplicating a bunch of work in the scheduler / cpufreq
/ power tracking. I wanted avoid such an figure out what exactly all
this existing code is doing. Right now I am just interested in how the
kernel is accounting for cpu power, and less on the actual load
balancing work. In particular, total power consumed over the lifetime
of the system, instead of what seems to be a diminished weighted scale
used for all the scheduler cpu_power calculations.

kernel/sched.c

First, the arch_scale_freq_power() hooks, what are the units that all
these calculations are based off of?
In update_cup_power() It seems "power" gets multiplied by
SCHED_LOAD_SCALE, then >> by SCHED_LOAD_SHIFT. (1024 *=1024) >> 10.

For Android, at least with omap, msm, tegra platforms I am attempting
to get cpu power tracking (with cpufreq support) and it looks like
there is some half-way support with x86.

It seems that for x86 the kernel returns the default value, which is
SCHED_LOAD_SCALE (1 << 10). Does anyone know how the magic number 1024
translates to cpu power consumption (with frequency scaling) in
relative or absolute power numbers.

-- Mike
