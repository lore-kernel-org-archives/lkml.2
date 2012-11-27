Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2K0P3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:29:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42681 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2K0P3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:29:46 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: add missing support for transmute bit in
 smack_str_from_perm()
Date: Tue, 27 Nov 2012 16:29:07 +0100
Message-id: <1354030147-32577-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes audit logs for granting or denial of permissions to show
information about transmute bit.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack_access.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index db14689..2e397a8 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -252,6 +252,8 @@ static inline void smack_str_from_perm(char *string, int access)
 		string[i++] = 'x';
 	if (access & MAY_APPEND)
 		string[i++] = 'a';
+	if (access & MAY_TRANSMUTE)
+		string[i++] = 't';
 	string[i] = '\0';
 }
 /**
-- 
1.7.10.4

