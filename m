Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2ISGni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:43:38 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:46474 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab2ISGnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:43:37 -0400
From: hongfeng <hongfeng@marvell.com>
To: akpm@linux-foundation.org, gorcunov@openvz.org, keescook@chromium.org,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, hongfeng <hongfeng@marvell.com>
Subject: [PATCH V2] poweroff: fix bug in orderly_poweroff
Date: Wed, 19 Sep 2012 14:37:57 +0800
Message-Id: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 19 Sep 2012 06:38:00.0293 (UTC) FILETIME=[4FF98950:01CD9631]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

orderly_poweroff is trying to poweroff platform by two steps:
step 1: Call userspace application to poweroff
step 2: If userspace poweroff fail, then do a force power off if force param is set.

The bug here is, step 1 is always successful with param UMH_NO_WAIT,
should change to UMH_WAIT_EXEC which will monitor whether user application successful run.

Change-Id: I2f9ebbb90c0c2443780080ec9507c8d004e5da74
Signed-off-by: Feng Hong <hongfeng@marvell.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 241507f..a624d4c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2204,7 +2204,7 @@ static int __orderly_poweroff(void)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
+	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
 				      NULL, argv_cleanup, NULL);
 	if (ret == -ENOMEM)
 		argv_free(argv);
-- 
1.7.0.4

