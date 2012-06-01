Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab2FAWTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:19:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54292 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573Ab2FAWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Avik Sil <avik.sil@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/15] perf tools: Fix pager on minimal-install embedded systems
Date: Fri,  1 Jun 2012 19:16:27 -0300
Message-Id: <1338588999-32509-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avik Sil <avik.sil@linaro.org>

Some Distributions may lack "less" package being included by default,
e.g., Linaro nano rootfs. In those cases use the portable "pager"
command instead of "less".

Signed-off-by: Avik Sil <avik.sil@linaro.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338287725-26382-1-git-send-email-avik.sil@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pager.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 1915de2..3322b84 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,6 +57,10 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
+	if (!pager) {
+		if (!access("/usr/bin/pager", X_OK))
+			pager = "/usr/bin/pager";
+	}
 	if (!pager)
 		pager = "less";
 	else if (!*pager || !strcmp(pager, "cat"))
-- 
1.7.1

