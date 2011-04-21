Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1DUUER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1DUUEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/4] perf, x86: collection of pentium 4 fixes
Date: Thu, 21 Apr 2011 11:03:19 -0400
Message-Id: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series has various clean ups for the P4 perf nmi layer.
Some of the changes touch the other platforms but those should be minimally
intrusive.

It would be nice to get these into 2.6.39 as two patches fix 'unknown' NMIs,
which is listed as a regression from 2.6.38.

Cyrill Gorcunov (3):
  perf, x86: P4 PMU -- Use perf_sample_data_init helper
  perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on
    overflow
  perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event

Don Zickus (1):
  perf, nmi: Move LVT un-masking into irq handlers

 arch/x86/kernel/cpu/perf_event.c       |    5 ++-
 arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    4 +++
 arch/x86/kernel/cpu/perf_event_p4.c    |   34 +++++++++++++++++++++++++------
 arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
 include/linux/perf_event.h             |    1 +
 kernel/watchdog.c                      |    2 +-
 7 files changed, 38 insertions(+), 10 deletions(-)

-- 
1.7.4.2

