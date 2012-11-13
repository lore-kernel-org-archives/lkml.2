Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2KMJIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:08:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53111 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2KMJH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:07:58 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, yinghai@kernel.org, mingo@redhat.com,
        vgoyal@redhat.com, khalid@gonehiking.org
Message-Id: <20121113090241.1180.73385.sendpatchset@indoh>
In-Reply-To: <20121113090212.1180.12233.sendpatchset@indoh>
References: <20121113090212.1180.12233.sendpatchset@indoh>
Subject: [PATCH v6 3/5] Make reset_devices available at early stage
Date: Tue, 13 Nov 2012 18:07:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change reset_devices from __setup to early_param so this parameter is
available at early stage.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index e33e09d..f2b24cb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -144,10 +144,10 @@ EXPORT_SYMBOL(reset_devices);
 static int __init set_reset_devices(char *str)
 {
 	reset_devices = 1;
-	return 1;
+	return 0;
 }
 
-__setup("reset_devices", set_reset_devices);
+early_param("reset_devices", set_reset_devices);
 
 static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
 const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
-- 
1.7.1


