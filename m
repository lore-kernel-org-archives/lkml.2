Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1EHWpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:45:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab1EHWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AEAGuMdCr6VIZcNw0WrcxnPgMQb6jZL0RSEVqueVfZzCr39igJHamIatbhgahvj9hI
         78Yi33lQBBLUpPmcuCYfiptj9bsisYX6gwhTkPxzLmS/bX9Lrm8fcTsZWntGm8T+7n0Z
         ZBGdsdx+l6TbnLo1esjiIf9H8XSd3oR1S2sok=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 085/115] sysctl: single subheader path: kernel/sched_domain/CPU/DOMAIN/
Date: Mon,  9 May 2011 00:39:37 +0200
Message-Id: <1304894407-32201-86-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

