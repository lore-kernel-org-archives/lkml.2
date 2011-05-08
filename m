Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab1EHWol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:44:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53450 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab1EHWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vy0JXCUsWtDpu/Ol/m8cmOoS1B/gCOSMIXOzYWfavuy1+vVvop5pNW0KdmKJNRAYEk
         MoA2CFvEde25FD1nrRPDu+gZdkzsKzHrLslOz8jZTkT0TZLqURffLxyLwNT1c1R/+ZgY
         ANbfFXcreqMT0XeMAiSNOH47+I36vBH8lrDDI=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 092/115] sysctl: sched: create empty dir with register_sysctl_dir
Date: Mon,  9 May 2011 00:39:44 +0200
Message-Id: <1304894407-32201-93-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/sched.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8320365..5cda526 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6302,16 +6302,11 @@ static void register_sched_domain_sysctl(void)
 
 	i = 0;
 	for_each_possible_cpu(cpu) {
-		struct ctl_table *empty = kzalloc(sizeof(*empty), GFP_KERNEL);
-		if (empty == NULL)
-			goto unregister_sd_cpudir_headers;
 		sd_path[SD_PATH_CPU].procname = sd_cpu_names[cpu];
 		sd_path[SD_PATH_DOM].procname = NULL; /* end of array sentinel */
-		sd_cpudir_headers[i] = register_sysctl_paths(sd_path, empty);
-		if (sd_cpudir_headers[i] == NULL) {
-			kfree(empty);
+		sd_cpudir_headers[i] = register_sysctl_dir(sd_path);
+		if (sd_cpudir_headers[i] == NULL)
 			goto unregister_sd_cpudir_headers;
-		}
 		i++;
 	}
 
@@ -6347,11 +6342,8 @@ unregister_sd_domain_headers:
 	i = sd_cpudir_headers_num;
 unregister_sd_cpudir_headers:
 	i--;
-	for(; i >= 0; i--) {
-		struct ctl_table *table = sd_cpudir_headers[i]->ctl_table_arg;
+	for(; i >= 0; i--)
 		unregister_sysctl_table(sd_cpudir_headers[i]);
-		kfree(table);
-	}
 
 	kfree(sd_domain_headers);
 fail_alloc_sd_domain_headers:
@@ -6391,11 +6383,8 @@ static void unregister_sched_domain_sysctl(void)
 		kfree(table);
 	}
 
-	for(i = sd_cpudir_headers_num - 1; i >= 0; i--) {
-		struct ctl_table *table = sd_cpudir_headers[i]->ctl_table_arg;
+	for(i = sd_cpudir_headers_num - 1; i >= 0; i--)
 		unregister_sysctl_table(sd_cpudir_headers[i]);
-		kfree(table);
-	}
 
 	kfree(sd_domain_headers);
 	kfree(sd_cpudir_headers);
-- 
1.7.5.134.g1c08b

