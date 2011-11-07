Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1KGMyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:54:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23841 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab1KGMyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:54:12 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 3/7] perf: add ability to record event period
Date: Mon,  7 Nov 2011 15:54:13 +0300
Message-Id: <1320670457-2633428-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-record.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f82480f..b62701a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -62,6 +62,7 @@ static bool			no_samples			=  false;
 static bool			sample_address			=  false;
 static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
+static bool			period				=  false;
 static bool			no_buildid_cache		=  false;
 static struct perf_evlist	*evsel_list;
 
@@ -185,6 +186,9 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	if (evlist->nr_entries > 1)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
+	if (period)
+		attr->sample_type |= PERF_SAMPLE_PERIOD;
+
 	/*
 	 * We default some events to a 1 default interval. But keep
 	 * it a weak assumption overridable by the user.
@@ -796,6 +800,7 @@ const struct option record_options[] = {
 	OPT_BOOLEAN('d', "data", &sample_address,
 		    "Sample addresses"),
 	OPT_BOOLEAN('T', "timestamp", &sample_time, "Sample timestamps"),
+	OPT_BOOLEAN('P', "period", &period, "Sample period"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
-- 
1.7.1

