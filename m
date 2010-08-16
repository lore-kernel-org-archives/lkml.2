Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0HPVHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:34501 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0HPVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:41 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Namhyung Kim <namhyung@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/5] kgdb: add missing __percpu markup in arch/x86/kernel/kgdb.c
Date: Mon, 16 Aug 2010 16:06:26 -0500
Message-Id: <1281992789-2471-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
References: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Aug 2010 21:06:36.0526 (UTC) FILETIME=[E9A8D8E0:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

breakinfo->pev is a pointer to percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index ef10940..852b819 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -194,7 +194,7 @@ static struct hw_breakpoint {
 	unsigned long		addr;
 	int			len;
 	int			type;
-	struct perf_event	**pev;
+	struct perf_event	* __percpu *pev;
 } breakinfo[HBP_NUM];
 
 static unsigned long early_dr7;
-- 
1.6.3.3

