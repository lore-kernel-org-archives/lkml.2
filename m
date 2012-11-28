Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2K1Nxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2K1Nxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:41 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 04/14] perf diff: Remove displacement from struct hist_entry_diff
Date: Wed, 28 Nov 2012 14:52:39 +0100
Message-Id: <1354110769-2998-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing displacement from struct hist_entry_diff, because
it's not used. Displacement is not used for sorting, so
there's no reason to pre-calculate it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b4e8c3b..a884be2 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -55,9 +55,6 @@ struct he_stat {
 struct hist_entry_diff {
 	bool	computed;
 
-	/* PERF_HPP__DISPL */
-	int	displacement;
-
 	/* PERF_HPP__DELTA */
 	double	period_ratio_delta;
 
-- 
1.7.11.7

