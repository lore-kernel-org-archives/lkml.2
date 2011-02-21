Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1BUEFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:05:23 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:33035
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754983Ab1BUEFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:05:20 -0500
Date: Mon, 21 Feb 2011 04:05:27 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Oleg Nesterov <oleg@redhat.com>, serge@hallyn.com,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com, Daniel Lezcano <daniel.lezcano@free.fr>
Subject: [PATCH 4/4] userns: uts and ipc: fix checkpatch warning
Message-ID: <20110221040527.GD12580@mail.hallyn.com>
References: <20110221040156.GA12580@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221040156.GA12580@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Andrew Morton (and checkpatch), init/version.c
(and ipc/msgutil.c) should not have an extern declaration for
init_user_ns.  Instead, move those to ipc_namespace.h and utsname.h.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 include/linux/ipc_namespace.h |    3 ++-
 include/linux/utsname.h       |    1 +
 init/version.c                |    1 -
 ipc/msgutil.c                 |    2 --
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 9974429..ebd4a93 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -15,6 +15,8 @@
 
 #define IPCNS_CALLBACK_PRI 0
 
+struct user_namespace;
+extern struct user_namespace init_user_ns;
 
 struct ipc_ids {
 	int in_use;
@@ -24,7 +26,6 @@ struct ipc_ids {
 	struct idr ipcs_idr;
 };
 
-struct user_namespace;
 struct ipc_namespace {
 	atomic_t	count;
 	struct ipc_ids	ids[3];
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 165b17b..69957ca 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -38,6 +38,7 @@ struct new_utsname {
 #include <linux/err.h>
 
 struct user_namespace;
+extern struct user_namespace init_user_ns;
 
 struct uts_namespace {
 	struct kref kref;
diff --git a/init/version.c b/init/version.c
index 97bb86f..86fe0cc 100644
--- a/init/version.c
+++ b/init/version.c
@@ -21,7 +21,6 @@ extern int version_string(LINUX_VERSION_CODE);
 int version_string(LINUX_VERSION_CODE);
 #endif
 
-extern struct user_namespace init_user_ns;
 struct uts_namespace init_uts_ns = {
 	.kref = {
 		.refcount	= ATOMIC_INIT(2),
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index d91ff4b..8b5ce5d 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -20,8 +20,6 @@
 
 DEFINE_SPINLOCK(mq_lock);
 
-extern struct user_namespace init_user_ns;
-
 /*
  * The next 2 defines are here bc this is the only file
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
-- 
1.7.0.4

