Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0JEMNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:13:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085Ab0JEMNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:13:42 -0400
Date: Tue, 5 Oct 2010 12:13:24 GMT
From: tip-bot for Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, frederik.deweerdt@xprog.eu,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, frederik.deweerdt@xprog.eu,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <20100923201901.GE31726@gambetta>
References: <20100923201901.GE31726@gambetta>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui hist browser: Fix segfault on 'a' for annotate
Message-ID: <tip-c569d3326bca6774f6c23f1dc91acad5400b6409@git.kernel.org>
Git-Commit-ID: c569d3326bca6774f6c23f1dc91acad5400b6409
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 12:13:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c569d3326bca6774f6c23f1dc91acad5400b6409
Gitweb:     http://git.kernel.org/tip/c569d3326bca6774f6c23f1dc91acad5400b6409
Author:     Frederik Deweerdt <frederik.deweerdt@xprog.eu>
AuthorDate: Thu, 23 Sep 2010 22:19:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Oct 2010 12:08:37 -0300

perf ui hist browser: Fix segfault on 'a' for annotate

There a typo in util/ui/browsers/hists.c that leads to a segfault when you
press the 'a' key on a non-resolved symbol (plain hex address).

LKML-Reference: <20100923201901.GE31726@gambetta>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index dafdf67..6866aa4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -773,7 +773,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 			switch (key) {
 			case 'a':
-				if (browser->selection->map == NULL &&
+				if (browser->selection->map == NULL ||
 				    browser->selection->map->dso->annotate_warned)
 					continue;
 				goto do_annotate;
