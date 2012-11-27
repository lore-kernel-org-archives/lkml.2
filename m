Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2K0AnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:43:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52137 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab2K0AnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:43:01 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, yinghai@kernel.org, mingo@redhat.com,
        vgoyal@redhat.com, khalid@gonehiking.org
Message-Id: <20121127004213.3604.53413.sendpatchset@tindoh.g01.fujitsu.local>
In-Reply-To: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
Subject: [PATCH v7 3/5] Make reset_devices available at early stage
Date: Tue, 27 Nov 2012 09:42:59 +0900 (JST)
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


