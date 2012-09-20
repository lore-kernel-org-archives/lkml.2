Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2ITOla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab2ITOl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:41:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 01/10] Secure boot: Add new capability
Date: Thu, 20 Sep 2012 10:40:56 -0400
Message-Id: <1348152065-31353-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Secure boot adds certain policy requirements, including that root must not
be able to do anything that could cause the kernel to execute arbitrary code.
The simplest way to handle this would seem to be to add a new capability
and gate various functionality on that. We'll then strip it from the initial
capability set if required.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 include/linux/capability.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index d10b7ed..4345bc8 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -364,7 +364,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow things that trivially permit root to modify the running kernel */
+
+#define CAP_COMPROMISE_KERNEL  37
+
+#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.7.11.4

