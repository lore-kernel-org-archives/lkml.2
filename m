Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1JONOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:14:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1JONOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:14:04 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/5] ipc/sem.c: multiple fixes
Date: Sat, 15 Oct 2011 15:21:19 +0200
Message-Id: <1318684879-1887-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The wakeup scheme used by semtimedop() does not work as intended on -rt.

The following series:
- fixes one bug that I noticed while thinking about a -rt compatible
  implementation
- prevents the code from returning to user space due to spurious wakeups.
  (noticed by Peter Zijlstra)
- moves private structures from include/linux/sem.h to ipc/sem.c
- saves some memory if sysvipc is disabled.
- reworks the wakeup scheme and adds a 2nd wakeup scheme that is based
  on a completion. For CONFIG_PREEMPT_RT_BASE, this scheme is used.

What do you think?
The rework of the wakeup should also help to convert the code to
using the wake_up_list framework.

Andrew: Could you replace the patches in -mm with this series?
I would prefer to keep the current scheme as the default, it's
~5% faster (6.5 usec vs. 6.8 usec per wakeup).

The patches pass checkpatch.pl and I didn't observe any problems
with my test apps.

--
	Manfred
