Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2FFHAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:00:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2FFHAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:00:20 -0400
Date: Wed, 6 Jun 2012 00:00:03 -0700
From: tip-bot for Avik Sil <avik.sil@linaro.org>
Message-ID: <tip-ea1b3ebac9a1c72c4362c784b4ed069a938a4ddb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        avik.sil@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avik.sil@linaro.org, tglx@linutronix.de
In-Reply-To: <1338287725-26382-1-git-send-email-avik.sil@linaro.org>
References: <1338287725-26382-1-git-send-email-avik.sil@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix pager on minimal-install embedded systems
Git-Commit-ID: ea1b3ebac9a1c72c4362c784b4ed069a938a4ddb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:00:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea1b3ebac9a1c72c4362c784b4ed069a938a4ddb
Gitweb:     http://git.kernel.org/tip/ea1b3ebac9a1c72c4362c784b4ed069a938a4ddb
Author:     Avik Sil <avik.sil@linaro.org>
AuthorDate: Tue, 29 May 2012 16:05:25 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 May 2012 15:10:39 -0300

perf tools: Fix pager on minimal-install embedded systems

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
