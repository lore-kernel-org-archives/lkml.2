Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2GDDcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2GDDcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:32:11 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [Patch] kernel/sys.c: fix an incorrect error branch in orderly_poweroff()
Date: Wed,  4 Jul 2012 11:31:47 +0800
Message-Id: <1341372710-14648-1-git-send-email-amwang@redhat.com>
In-Reply-To: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

When argv_split() fails, argv is NULL, thus we should avoid calling
agrv_free(argv), and should jump after it.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/kernel/sys.c b/kernel/sys.c
index e0c8ffc..ffa510f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2217,13 +2217,13 @@ int orderly_poweroff(bool force)
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
 	if (likely(!ret))
 		return 0;
 
 	if (ret == -ENOMEM)
 		argv_free(argv);
 
+out:
 	if (force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");
