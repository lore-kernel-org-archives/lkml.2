Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2E2Kfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:35:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57162 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2E2Kfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:35:39 -0400
From: Avik Sil <avik.sil@linaro.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Perf: Use /usr/bin/pager if available for perf pager
Date: Tue, 29 May 2012 16:05:25 +0530
Message-Id: <1338287725-26382-1-git-send-email-avik.sil@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Distributions may lack "less" package being included by default, e.g., Linaro nano rootfs. In those cases use the portable "pager" command instead of "less".

Signed-off-by: Avik Sil <avik.sil@linaro.org>
---
 tools/perf/util/pager.c |    4 ++++
 1 file changed, 4 insertions(+)

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
1.7.9.5

