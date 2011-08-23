Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1HWHYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:24:02 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61948 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1HWHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:24:00 -0400
Subject: [PATCH] CRED: fix build error due to 'tgcred' undeclared
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 15:23:51 +0800
Message-ID: <1314084231.5033.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_KEYS guard for tgcred to fix below build error
if CONFIG_KEYS is not configured.

  CC      kernel/cred.o
kernel/cred.c: In function 'prepare_kernel_cred':
kernel/cred.c:657: error: 'tgcred' undeclared (first use in this function)
kernel/cred.c:657: error: (Each undeclared identifier is reported only once
kernel/cred.c:657: error: for each function it appears in.)
make[1]: *** [kernel/cred.o] Error 1
make: *** [kernel] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 kernel/cred.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index bb2c0f5..5791612 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -654,11 +654,13 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (!new)
 		return NULL;
 
+#ifdef CONFIG_KEYS
 	tgcred = kmalloc(sizeof(*tgcred), GFP_KERNEL);
 	if (!tgcred) {
 		kmem_cache_free(cred_jar, new);
 		return NULL;
 	}
+#endif
 
 	kdebug("prepare_kernel_cred() alloc %p", new);
 
-- 
1.7.4.1



