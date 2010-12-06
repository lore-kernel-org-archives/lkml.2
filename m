Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0LFWGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:06:50 -0500
Received: from mail.perches.com ([173.55.12.10]:2347 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/29] kernel: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:14 -0800
Message-Id: <405f6d9400e07f78048aa88307c2cfbc5be4849c.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.
Add missing newlines.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/notifier.c      |    2 +-
 kernel/pm_qos_params.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2488ba7..ff6a774 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -85,7 +85,7 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 
 #ifdef CONFIG_DEBUG_NOTIFIERS
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
-			WARN(1, "Invalid notifier called!");
+			WARN(1, "Invalid notifier called!\n");
 			nb = next_nb;
 			continue;
 		}
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index aeaa7f8..a7abb8b 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -231,7 +231,7 @@ void pm_qos_add_request(struct pm_qos_request_list *dep,
 	int new_value;
 
 	if (pm_qos_request_active(dep)) {
-		WARN(1, KERN_ERR "pm_qos_add_request() called for already added request\n");
+		WARN(1, "%s() called for already added request\n", __func__);
 		return;
 	}
 	if (value == PM_QOS_DEFAULT_VALUE)
@@ -264,7 +264,7 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
 		return;
 
 	if (!pm_qos_request_active(pm_qos_req)) {
-		WARN(1, KERN_ERR "pm_qos_update_request() called for unknown object\n");
+		WARN(1, "%s() called for unknown object\n", __func__);
 		return;
 	}
 
@@ -297,7 +297,7 @@ void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req)
 		/* silent return to keep pcm code cleaner */
 
 	if (!pm_qos_request_active(pm_qos_req)) {
-		WARN(1, KERN_ERR "pm_qos_remove_request() called for unknown object\n");
+		WARN(1, "%s() called for unknown object\n", __func__);
 		return;
 	}
 
-- 
1.7.3.2.245.g03276.dirty

