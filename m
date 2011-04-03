Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1DCXBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:01:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64389 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DCXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cKKUUgBEZl1LMHkGufrv13/RrWhX18cJSGMTMmHGhTepCSkFfdGcVLEhQtr4HB6SEQ
         1vkRQYsrP/lfafA48ueV1rA7sLtBFxIKMd42be13iceZr8HQx5eMSAatDZfjLaqGMYLC
         gV8CU58SukrSjtSSoG9B/dgRmHeGpMqKwiQp4=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, acme@ghostprotocols.net, paulus@samba.org,
        mingo@elte.hu, fweisbec@gmail.com, daahern@cisco.co,
        imunsie@au.ibm.com
Subject: [PATCH 1/1] perf: Use ARRAY_SIZE macro in trace-event-parse.c.
Date: Sun,  3 Apr 2011 20:00:55 -0300
Message-Id: <1301871655-17038-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..7c24247 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2195,7 +2195,7 @@ static const struct flag flags[] = {
 
 unsigned long long eval_flag(const char *flag)
 {
-	int i;
+	unsigned int i;
 
 	/*
 	 * Some flags in the format files do not get converted.
@@ -2205,7 +2205,7 @@ unsigned long long eval_flag(const char *flag)
 	if (isdigit(flag[0]))
 		return strtoull(flag, NULL, 0);
 
-	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
+	for (i = 0; i < ARRAY_SIZE(flags); i++)
 		if (strcmp(flags[i].name, flag) == 0)
 			return flags[i].value;
 
-- 
1.7.3.2.343.g7d43d

