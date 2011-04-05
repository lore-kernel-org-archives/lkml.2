Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1DEPb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:60399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1DEPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:24 -0400
Message-Id: <20110405152338.692966333@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/21] sched: Reduce runqueue lock contention -v6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to optimize remote wakeups by moving most of the
work of the wakeup to the remote cpu and avoid bouncing runqueue data
structures where possible.

As measured by sembench (which basically creates a wakeup storm) on my
dual-socket westmere:

$ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance > $i; done
$ echo 4096 32000 64 128 > /proc/sys/kernel/sem
$ ./sembench -t 2048 -w 1900 -o 0

unpatched: run time 30 seconds 647278 worker burns per second
patched:   run time 30 seconds 816715 worker burns per second

I've queued this series for .40.

