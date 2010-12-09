Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0LIRau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:30:50 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:57147
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755901Ab0LIRas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:30:48 -0500
Date: Thu, 9 Dec 2010 17:30:50 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: LSM <linux-security-module@vger.kernel.org>
Cc: containers@lists.linux-foundation.org, Kees Cook <kees.cook@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 3/4] allow sethostname in a container
Message-ID: <20101209173050.GA10206@mail.hallyn.com>
References: <20101209172027.GA10085@mail.hallyn.com>
 <20101209172843.GA10155@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209172843.GA10155@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To test this, you can:
	1. clone a new user namespace without a new uts namespace.
	   You can NOT set hostname.
	2. clone both a new user and uts namespace.  You can set
	   hostname.

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
1.7.2.3

