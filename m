Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1ADIUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:20:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:50109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1ADIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:20:42 -0500
Date: Tue, 4 Jan 2011 08:19:56 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, edwintorok@gmail.com,
        imunsie@au1.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, edwintorok@gmail.com,
        imunsie@au1.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix event ordering settings to work with older kernels
Message-ID: <tip-ce0ac9e1851364fa67c991659ce1db05ab82c6ae@git.kernel.org>
Git-Commit-ID: ce0ac9e1851364fa67c991659ce1db05ab82c6ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:19:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce0ac9e1851364fa67c991659ce1db05ab82c6ae
Gitweb:     http://git.kernel.org/tip/ce0ac9e1851364fa67c991659ce1db05ab82c6ae
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 25 Dec 2010 18:33:12 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 25 Dec 2010 18:33:12 -0200

perf script: Fix event ordering settings to work with older kernels

If we don't use .ordering_requires_timestamps we'll end up trying to order
events with no timestamps when running on older kernels.

Problem introduced in eac23d1c.

After the last three fixes, perf scripting is back working, tested with
new perf userspace on old and new (with sample_id_all) kernels.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Torok Edwin <edwintorok@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6ef65c0..43480fd 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -117,6 +117,7 @@ static struct perf_event_ops event_ops = {
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
 	.lost = process_lost_event,
+	.ordering_requires_timestamps = true,
 	.ordered_samples = true,
 };
 
