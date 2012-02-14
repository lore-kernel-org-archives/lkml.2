Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2BNQy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:54:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab2BNQyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:54:24 -0500
Date: Tue, 14 Feb 2012 17:47:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] usermodehelper: introduce umh_complete(sub_info)
Message-ID: <20120214164741.GA21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation. Add the new trivial helper, umh_complete(). Currently
it simply does complete(sub_info->complete).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index a0a8854..8ea2594 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -199,6 +199,11 @@ void call_usermodehelper_freeinfo(struct subprocess_info *info)
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	complete(sub_info->complete);
+}
+
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -235,7 +240,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	complete(sub_info->complete);
+	umh_complete(sub_info);
 	return 0;
 }
 
@@ -269,7 +274,7 @@ static void __call_usermodehelper(struct work_struct *work)
 	case UMH_WAIT_EXEC:
 		if (pid < 0)
 			sub_info->retval = pid;
-		complete(sub_info->complete);
+		umh_complete(sub_info);
 	}
 }
 
-- 
1.5.5.1


