Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1LUIlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:41:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1LUIlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:41:47 -0500
Date: Wed, 21 Dec 2011 00:41:31 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-f3bda2c9a689b38c059f7cb2d761ff58a2996370@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323966762-8574-2-git-send-email-robert.richter@amd.com>
References: <1323966762-8574-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Fix uninitialized memory access to struct perf_sample
Git-Commit-ID: f3bda2c9a689b38c059f7cb2d761ff58a2996370
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:41:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3bda2c9a689b38c059f7cb2d761ff58a2996370
Gitweb:     http://git.kernel.org/tip/f3bda2c9a689b38c059f7cb2d761ff58a2996370
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:32:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:26:47 -0200

perf evsel: Fix uninitialized memory access to struct perf_sample

Memory in struct perf_sample is not fully initialized during parsing.
Depending on sampling data some parts may left unchanged. Zero out
struct perf_sample first to avoid access to uninitialized memory.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1323966762-8574-2-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 60ad028..667f3b7 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -460,7 +460,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		u32 val32[2];
 	} u;
 
-
+	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 
