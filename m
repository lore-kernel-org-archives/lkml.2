Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0EMGEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:46 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34093 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0EMGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:43 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/7] perf trace: Defensive programming
Date: Thu, 13 May 2010 16:03:46 +1000
Message-Id: <1273730632-21008-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch makes the failure case where the size that read_size is
passed is invalid kill perf immediately rather than silently failing, so
that further bugs or regressions using read_size can be found more
easily and squashed early.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/trace-event-parse.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..8f470f6 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1912,8 +1912,7 @@ unsigned long long read_size(void *ptr, int size)
 	case 8:
 		return data2host8(ptr);
 	default:
-		/* BUG! */
-		return 0;
+		die("read_size BUG: Invalid size %d", size);
 	}
 }
 
-- 
1.7.1

