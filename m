Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1AJVMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:12:13 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:34281
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753751Ab1AJVMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:12:07 -0500
Date: Mon, 10 Jan 2011 21:13:25 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH 3/7] allow sethostname in a container
Message-ID: <20110110211325.GC22564@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110211135.GA22446@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 2745dcd..9b9b03b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1171,7 +1171,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
-- 
1.7.0.4

