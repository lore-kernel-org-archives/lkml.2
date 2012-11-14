Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2KNG1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:27:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2KNG1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:27:21 -0500
Date: Tue, 13 Nov 2012 22:27:10 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-1234471e2d11e4ee47f6de452dd8b8aeb09b45de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, drjones@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, drjones@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1350999890-6920-1-git-send-email-namhyung@kernel.org>
References: <1350999890-6920-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf header: Fix numa topology printing
Git-Commit-ID: 1234471e2d11e4ee47f6de452dd8b8aeb09b45de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:27:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1234471e2d11e4ee47f6de452dd8b8aeb09b45de
Gitweb:     http://git.kernel.org/tip/1234471e2d11e4ee47f6de452dd8b8aeb09b45de
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 23 Oct 2012 22:44:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Oct 2012 10:32:55 -0200

perf header: Fix numa topology printing

Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
processed session env when printing") regresses the header output.  It
was because of a missed string pointer calculation in the loop.

Reported-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1350999890-6920-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..566b84c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1378,6 +1378,8 @@ static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
 
 		str = tmp + 1;
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+
+		str += strlen(str) + 1;
 	}
 	return;
 error:
