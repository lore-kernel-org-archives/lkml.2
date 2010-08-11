Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0HKJ2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 05:28:11 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:34481 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0HKJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 05:28:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: john.johansen@canonical.com
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>
Subject: [PATCH 1/1] AppArmor: fix task_setrlimit prototype
Date: Wed, 11 Aug 2010 11:28:02 +0200
Message-Id: <1281518882-4130-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After rlimits tree was merged we get the following errors:
security/apparmor/lsm.c:663:2: warning: initialization from incompatible pointer type

It is because AppArmor was merged in the meantime, but uses the old
prototype. So fix it by adding struct task_struct as a first parameter
of apparmor_task_setrlimit.

NOTE that this is ONLY a compilation warning fix (and crashes caused
by that). It needs proper handling in AppArmor depending on who is the
'task'.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
---
 security/apparmor/lsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8db33a8..06f4d02 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -607,8 +607,8 @@ static int apparmor_setprocattr(struct task_struct *task, char *name,
 	return error;
 }
 
-static int apparmor_task_setrlimit(unsigned int resource,
-				   struct rlimit *new_rlim)
+static int apparmor_task_setrlimit(struct task_struct *task,
+		unsigned int resource, struct rlimit *new_rlim)
 {
 	struct aa_profile *profile = aa_current_profile();
 	int error = 0;
-- 
1.7.2.1


