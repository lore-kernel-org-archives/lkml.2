Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0HOQpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:45:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37407 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab0HOQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MzItobIBq1LVQmWSxC4Mzv0cX6KlVI5HNH40bZhjj2IvvbspOFwk5r/7htUndwSkVa
         DthVL/I0j1nlDGPq5+9Ur4UlGJwoiDNMlNtG0h7BGg5oP59iHKCO5UquJAqkldeinqUE
         La6LJmCE9eZGFFMidjgCRMzRqgTF8uUSwm8rc=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init/main.c: refactor maxcpus()
Date: Sun, 15 Aug 2010 18:35:33 +0900
Message-Id: <1281864933-6145-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_option() requires 2nd arg to be a pointer to int but setup_max_cpus is a
pointer to unsigned int. Use max_cpus instead and update setup_max_cpus only
if given value is in the proper range.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 86cbfd0..b06b8f2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -165,9 +165,13 @@ early_param("nr_cpus", nrcpus);
 
 static int __init maxcpus(char *str)
 {
-	get_option(&str, &setup_max_cpus);
-	if (setup_max_cpus == 0)
-		arch_disable_smp_support();
+	int max_cpus;
+
+	get_option(&str, &max_cpus);
+	if (max_cpus == 0)
+		nosmp(NULL);
+	else if (0 < max_cpus && max_cpus < NR_CPUS)
+		setup_max_cpus = max_cpus;
 
 	return 0;
 }
-- 
1.7.0.4

