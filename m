Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534Ab1EABjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab1EABiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N1JNcQtZo6JbQ5UqVdI6Fn5YYu290kGwh6i9kwyVYZ+SOykBW+7fb2qXa22jsdE46l
         Ui4GyoFNc/ZJ+5RCiSp+OQoug0k9zhkcjphzehq6jWUq+8o4cRSQKoMQMNNhLMs3if0F
         cFXwZCP6i1Ki/Oxhoqhg+Txto9OWITwGRJpfQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 67/69] sysctl: single subheader path: kernel/sched_domain/CPU/DOMAIN/
Date: Sun,  1 May 2011 03:36:37 +0200
Message-Id: <1304213799-10257-68-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/sched.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6e39b7c..8320365 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6250,7 +6250,13 @@ static void register_sched_domain_sysctl(void)
 		{ .procname = "kernel" },
 		{ .procname = "sched_domain" },
 		{ /* 'cpu0' */ },
-		{ /* 'domain0' */ },
+		{
+			/* 'domain0' */
+			.procname = NULL,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{  },
 	};
 
-- 
1.7.5.134.g1c08b

