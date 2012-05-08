Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2EHB7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 21:59:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45852 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab2EHB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 21:59:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: jolsa@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf report: fix compile failure on ppc, 32-bit
Date: Mon,  7 May 2012 19:59:22 -0600
Message-Id: <1336442362-53217-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Builds currently fail with:
    CC /tmp/pbuild/builtin-report.o
cc1: warnings being treated as errors
builtin-report.c: In function ‘hists__fprintf_nr_sample_events’:
builtin-report.c:307: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘u64’
make: *** [/tmp/pbuild/builtin-report.o] Error 1

$ rpm -q gcc
gcc-4.4.4-10.fc12.ppc

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5df829f..7477655 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -304,7 +304,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
+	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
-- 
1.7.5.4

