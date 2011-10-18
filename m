Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1JRLep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:34:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63907 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1JRLen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:34:43 -0400
From: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
Subject: [PATCH] Smack: fix: invalid length set for the result of /smack/access
Date: Tue, 18 Oct 2011 14:34:28 +0300
Message-Id: <1318937668-3602-1-git-send-email-jarkko.j.sakkinen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to update simple_transaction_set() to take terminator
character into account.

Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
---
 security/smack/smackfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5498c4a..381eecf 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1514,7 +1514,7 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
 	data[0] = res == 0 ? '1' : '0';
 	data[1] = '\0';
 
-	simple_transaction_set(file, 1);
+	simple_transaction_set(file, 2);
 	return SMK_LOADLEN;
 }
 
-- 
1.7.5.4

