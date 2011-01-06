Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab1AFIZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:25:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1AFIZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:25:42 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org
Subject: [Patch] kexec_load: check CAP_SYS_MODULE
Date: Thu,  6 Jan 2011 16:25:25 +0800
Message-Id: <1294302325-22593-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric pointed out that kexec_load() actually allows you to
run any code you want in ring0, this is more like CAP_SYS_MODULE.

Reported-by: Eric Paris <eparis@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/kernel/kexec.c b/kernel/kexec.c
index b55045b..c30d613 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -945,7 +945,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || !capable(CAP_SYS_MODULE))
 		return -EPERM;
 
 	/*
