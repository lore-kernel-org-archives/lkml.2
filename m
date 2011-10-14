Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1JNKQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 06:16:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53302 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1JNKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 06:16:54 -0400
From: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
Subject: [PATCH] Smack: compilation fix
Date: Fri, 14 Oct 2011 13:16:24 +0300
Message-Id: <1318587384-2737-1-git-send-email-jarkko.j.sakkinen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some build configurations PER_CLEAR_ON_SETID symbol was not
found when compiling smack_lsm.c. This patch fixes the issue by
explicitly doing #include <linux/personality.h>.

Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
---
 security/smack/smack_lsm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d55b991..7db62b4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -35,6 +35,7 @@
 #include <linux/audit.h>
 #include <linux/magic.h>
 #include <linux/dcache.h>
+#include <linux/personality.h>
 #include "smack.h"
 
 #define task_security(task)	(task_cred_xxx((task), security))
-- 
1.7.5.4

