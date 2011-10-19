Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab1JSRh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:37:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51625 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1JSRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:37:56 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf top: do not exit tui on tab key with single event
Date: Wed, 19 Oct 2011 11:37:47 -0600
Message-Id: <1319045867-12728-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TUI help states for multiple event sessions the TAB/UNTAB keys are
used to switch events. For single event sessions (e.g., the default)
the tab key currently causes the tui to exit. Change that to do
nothing since there is not no second event to switch to.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 936e641..78ae9b8 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -868,6 +868,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		switch (key) {
 		case NEWT_KEY_TAB:
 		case NEWT_KEY_UNTAB:
+			if (nr_events == 1)
+				continue;
 			/*
 			 * Exit the browser, let hists__browser_tree
 			 * go to the next or previous
-- 
1.7.6.4

