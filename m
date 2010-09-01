Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0IAC5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:57:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0IAC5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:57:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/4] nmi perf fixes
Date: Tue, 31 Aug 2010 22:56:42 -0400
Message-Id: <1283309806-21913-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes to allow unknown nmis to pass through the perf nmi handler instead
of being swallowed.  Contains patches that are already in Ingo's tree.  Added
here for completeness.  Based on ingo/tip

Tested on intel/amd

git pull git://fedorapeople.org/dzickus/

Don Zickus (2):
  [x86] perf: rename nmi variable to avoid clash with entry point
  [x86] perf: fix accidentally ack'ing a second event on intel perf
    counter

Peter Zijlstra (1):
  perf, x86: Fix handle_irq return values

Robert Richter (1):
  perf, x86: Try to handle unknown nmis with an enabled PMU

 arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 3 files changed, 56 insertions(+), 20 deletions(-)

-- 
1.7.2.2

