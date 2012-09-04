Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2IDPzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab2IDPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:37 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 01/11] Secure boot: Add new capability
Date: Tue,  4 Sep 2012 11:55:07 -0400
Message-Id: <1346774117-2277-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1346774117-2277-1-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
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
index d10b7ed..6a39163 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -364,7 +364,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_BLOCK_SUSPEND    36
 
-#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
+/* Allow things that are dangerous under secure boot */
+
+#define CAP_SECURE_FIRMWARE  37
+
+#define CAP_LAST_CAP         CAP_SECURE_FIRMWARE
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.7.11.4

