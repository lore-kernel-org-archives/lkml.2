Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2IDP41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab2IDPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:45 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 07/11] kexec: Disable in a secure boot environment
Date: Tue,  4 Sep 2012 11:55:13 -0400
Message-Id: <1346774117-2277-8-git-send-email-mjg@redhat.com>
In-Reply-To: <1346774117-2277-1-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec could be used as a vector for a malicious user to use a signed kernel
to circumvent the secure boot trust model. In the long run we'll want to
support signed kexec payloads, but for the moment we should just disable
loading entirely in that situation.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0668d58..48852ec 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -944,7 +944,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || !capable(CAP_SECURE_FIRMWARE))
 		return -EPERM;
 
 	/*
-- 
1.7.11.4

