Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab1KNRwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:52:43 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:24887 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab1KNRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:52:41 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUNWAT-02-46E-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v3 0/2] perf, x86: handle overlapping counters
Date: Mon, 14 Nov 2011 18:51:09 +0100
Message-ID: <1321293071-8636-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20111111142935.GI15738@erda.amd.com>
References: <20111111142935.GI15738@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know there is an ongoing discussion about the best algorithm to be
used for this problem. Posting this version with the latest updates
anyway...

This patch set implements support for overlapping counters (patch #2).
For this the existing x86 event scheduler is reworked by introducing
helper functions (patch #1).

V2:
changes in patch #2:
* Renamed redo -> overlap.
* Reimplementation using perf scheduling helper functions.

V3:
changes in patch #1:
* Added macro for_each_set_bit_cont().
* Changed functions interfaces of perf_sched_find_counter() and
  perf_sched_next_event() to use bool as return value.
* Added some comments to make code better understandable.
changes in patch #2:
* Added WARN_ON_ONCE() if out of save states.
* Changed function interface of perf_sched_restore_state() to use bool
  as return value.

-Robert

Robert Richter (2):
  perf, x86: Implement event scheduler helper functions
  perf, x86: Fix event scheduler for constraints with overlapping
    counters

 arch/x86/kernel/cpu/perf_event.c     |  217 +++++++++++++++++++++++++---------
 arch/x86/kernel/cpu/perf_event.h     |   30 +++++-
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 include/linux/bitops.h               |   10 ++-
 4 files changed, 200 insertions(+), 59 deletions(-)

-- 
1.7.7


