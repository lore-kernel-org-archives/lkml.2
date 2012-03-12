Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2CLPNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:13:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34360 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2CLPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:13:51 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 1/2] perf report: remove duplicate annotate choice in branch view mode
Date: Mon, 12 Mar 2012 16:13:29 +0100
Message-Id: <1331565210-10865-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331565210-10865-1-git-send-email-eranian@google.com>
References: <1331565210-10865-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the duplicated annotate selection when browsing
in branch view mode. If the sym and dso oof the branch source and
target are the same, then only one annotate choice is proposed.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 951e2e9..40fd424 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -989,6 +989,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			    bi &&
 			    bi->to.sym != NULL &&
 			    !bi->to.map->dso->annotate_warned &&
+			    (bi->to.sym != bi->from.sym ||
+			     bi->to.map->dso != bi->from.map->dso) &&
 				asprintf(&options[nr_options], "Annotate %s",
 					 bi->to.sym->name) > 0)
 				annotate_t = nr_options++;
-- 
1.7.4.1

