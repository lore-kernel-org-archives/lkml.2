Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1KRLgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:36:00 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:28419 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab1KRLf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:35:57 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUUTJS-02-DWY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v4 0/2] perf, x86: handle overlapping counters
Date: Fri, 18 Nov 2011 12:35:20 +0100
Message-ID: <1321616122-1533-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
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

Version 4 of the patch set fixes a bug in the event assignment. There was a
problem if the first event's weight (index 0) is not the minimum weight. In
this case the event was assigned twice leaving another event uninitialized
which caused a GP while accessing counter msrs. Fixes this by proper
initialzing the first event in perf_sched_init().

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

V4:
changes in patch #1:
* Fix broken event assignment if weight of the first event is not
  wmin (perf_sched_init()).

Robert Richter (2):
  configs: updating misc-x86_64-erda to v3.0.8
  config: updating misc-x86_64-erda.config for ASUS M4A89GTD PRO

 configs/misc-x86_64-erda.config |  517 ++++++++++++++++++++++++++++-----------
 1 files changed, 379 insertions(+), 138 deletions(-)

-- 
1.7.7


