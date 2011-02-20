Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1BTHIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1BTHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QrOt/j6GKEl/vP901N8+cssa+eiuZ6O7qe/ODP/fZtXWb45RwHBc4NLKx3Ik0YNaCR
         UfKdwSjGpwaksGaL94852I68A8z0eTfBg7q4gFi5LgzyGRYn1J7PZx+8zt5fAa38XZp9
         aVXOLuncv0VKZY+A/yWvGiqXJXVrNB1TFVxQU=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/5] sched, autogroup, sysctl: use proc_dointvec_minmax instead.
Date: Sun, 20 Feb 2011 15:08:12 +0800
Message-Id: <1298185696-4403-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_autogroup_enabled has min/max value, proc_dointvec_minmax()
is be used for this case.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..22e07ee 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -374,7 +374,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-- 
1.7.1

