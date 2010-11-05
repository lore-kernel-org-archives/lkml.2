Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0KEXRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:17:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17658 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab0KEXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:17:51 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] watchdog: Fix section missmatch and potential undefined behavior.
Date: Fri,  5 Nov 2010 16:17:39 -0700
Message-Id: <1288999059-14573-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 05 Nov 2010 23:18:28.0025 (UTC) FILETIME=[C0BD8A90:01CB7D3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d9ca07a05ce1c42ac9717e54eaea4546a3a80978 introduces the section
missmatch.  Now that we reference no_watchdog from non-__init code it
can no longer be __initdata.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index bafba68..6e3c41a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -43,7 +43,7 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
 
-static int __initdata no_watchdog;
+static int no_watchdog;
 
 
 /* boot commands */
-- 
1.7.2.3

