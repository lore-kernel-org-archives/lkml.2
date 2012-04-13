Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2DMSYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:24:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2DMSYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:24:05 -0400
Date: Fri, 13 Apr 2012 11:23:53 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-5a7ed29c7572d00a75e8c4529e30c5ac2ef82271@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1333643188-26895-5-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Use sw counter only if hw pmu is not detected
Git-Commit-ID: 5a7ed29c7572d00a75e8c4529e30c5ac2ef82271
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:23:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a7ed29c7572d00a75e8c4529e30c5ac2ef82271
Gitweb:     http://git.kernel.org/tip/5a7ed29c7572d00a75e8c4529e30c5ac2ef82271
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:26:28 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 17:39:19 -0300

perf record: Use sw counter only if hw pmu is not detected

Use cpu-clock-tick sw counter for cpu-cycles only if there is no hw
pmu available. This is the case if the syscall reports ENOENT. In
other cases (e.g. invalid attributes) we don't want the sw counter to
be used.

Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1333643188-26895-5-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be4e1ee..10b1f1f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -245,7 +245,7 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE
+			if (err == ENOENT && attr->type == PERF_TYPE_HARDWARE
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
