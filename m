Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab2HJWY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:24:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39497 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2HJWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:24:52 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 06/16] perf symbol: remove unneeded call to dso__set_long_name()
Date: Fri, 10 Aug 2012 15:22:52 -0700
Message-Id: <1344637382-22789-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-7408-0000-0000-000007866704
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dso__set_long_name() is already called by dso__load_vmlinux(), avoid
calling it a second time unnecessarily.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9afe6b1..2127002 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1387,10 +1387,8 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, filter);
-		if (err > 0) {
-			dso__set_long_name(dso, filename);
+		if (err > 0)
 			goto out;
-		}
 		free(filename);
 	}
 
-- 
1.7.11.3

