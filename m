Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0J3VJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:52 -0400
Received: from mail.perches.com ([173.55.12.10]:3797 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0J3VJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/39] kernel: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:49 -0700
Message-Id: <8a52b500cdb1e4b0ebbe31f2e702c8a37022a776.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
index c7a8f45..4bf77d2 100644
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
1.7.3.1.g432b3.dirty

