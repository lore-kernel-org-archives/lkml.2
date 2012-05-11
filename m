Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2EKG1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:27:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2EKG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:27:20 -0400
Date: Thu, 10 May 2012 23:27:09 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-c651214e90e5c150015f7524a6bfc298ad61435f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1333643188-26895-2-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix include header files in util/
 parse-events.h
Git-Commit-ID: c651214e90e5c150015f7524a6bfc298ad61435f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:27:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c651214e90e5c150015f7524a6bfc298ad61435f
Gitweb:     http://git.kernel.org/tip/c651214e90e5c150015f7524a6bfc298ad61435f
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:26:25 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:14:35 -0300

perf tools: Fix include header files in util/parse-events.h

Include header fixes for

... bool:

 util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’

... and types.h:

 util/parse-events.h:28: error: expected ‘)’ before ‘config’
 util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
 util/parse-events.h:45: error: expected ‘)’ before ‘type’

This happens if now other include files are included before
util/parse-events.h.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ca069f8..5cb0028 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+#include <stdbool.h>
 #include "../../../include/linux/perf_event.h"
+#include "types.h"
 
 struct list_head;
 struct perf_evsel;
