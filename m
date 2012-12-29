Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2L2LBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 06:01:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10535 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2L2LBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 06:01:50 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: [PATCH] prctl: fix validation of an address
Date: Sat, 29 Dec 2012 15:00:10 +0400
Message-Id: <1356778810-20879-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address should be bigger than dac_mmap_min_addr, because
a process with CAP_RAWIO can map a vma bellow mmap_min_addr.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 265b376..e0e1bbd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1868,7 +1868,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE || addr < mmap_min_addr)
+	if (addr >= TASK_SIZE || addr < dac_mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
-- 
1.7.11.7

