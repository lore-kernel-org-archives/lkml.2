Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0LWP2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:28:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41518 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0LWP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=xwuwrYynOwSHyAD0tz7uvDiws2EDe66TIgcuZA44bwYwFQ7vVFU9K8lbOHpitXZiMi
         nLXwovnLTflmet0wy3SKlu9e78aKOZR/1S24D+WrPQWAamRJgwQ+Z6dlnR6TYAqIT07E
         nBCC8PanyYXrmxGD1qGg67cgzxYvLiHLWLp1c=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf-probe: no need to initialize the entire temporary buffers in synthesize_perf_probe_point()
Date: Thu, 23 Dec 2010 16:27:57 +0100
Message-ID: <m3wrn07blu.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

This patches only put a single null byte at the beginning of each
temporary buffers line[], offs[], file[] instead of filling their full
contents with null bytes.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index adc2620..e453f13 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1058,9 +1058,11 @@ error:
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 {
 	char *buf, *tmp;
-	char offs[32] = "", line[32] = "", file[32] = "";
+	char offs[32], line[32], file[32];
 	int ret, len;
 
+	offs[0] = line[0] = file[0] = '\0';
+
 	buf = zalloc(MAX_CMDLEN);
 	if (buf == NULL) {
 		ret = -ENOMEM;
-- 
1.7.3.2

