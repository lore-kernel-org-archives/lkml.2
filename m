Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0IHM3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:29:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:33876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab0IHM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:29:47 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Cc: peterz@infradead.org, Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Jan Blunck <jblunck@suse.de>
Subject: [RFC 0/4] Disable timer tick for SCHED_FIFO tasks
Date: Wed,  8 Sep 2010 14:29:20 +0200
Message-Id: <1283948964-6418-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches that I have been working on a few months ago.

For some applications (e.g. FTQ) you can see the jitter that is introduced by
the timer tick in the result data set. Therefore the task was to completely
disable the timer tick or at least reduce the impact on the application.

This patchset is reusing the infrastructure that disables the timer tick during
idle periods to disable it as well when SCHED_FIFO tasks are executed.

The results of the FTQ workload show that the timer tick is getting disabled
long periods but the impact of a single interruption seems to increase.
Possible, this is due to the fact that the timer tick needs to be enabled again
during interrupts.

Other known issues:
- Currently the time accounting is totally broken but that was not the primary
  focus.

Rants? Thoughts? Complaints?

 Jan


Jan Blunck (4):
  ftrace: Add events for tracing timer interrupts
  ftrace: Add events for tracing tick start and stop
  Disable scheduler tick when we are running SCHED_FIFO tasks
  ftrace: Add argument to tick start/stop tracing

 arch/x86/kernel/apic/apic.c  |    4 +++
 arch/x86/kernel/time.c       |    5 ++++
 include/linux/tick.h         |   14 +++++++++++-
 include/trace/events/irq.h   |   38 ++++++++++++++++++++++++++++++++++
 include/trace/events/sched.h |   46 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c            |   23 +++++++++++++++++++++
 kernel/softirq.c             |    5 ++++
 kernel/time/tick-sched.c     |   40 ++++++++++++++++++++++++-----------
 8 files changed, 160 insertions(+), 15 deletions(-)

