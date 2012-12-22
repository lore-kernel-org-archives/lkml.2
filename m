Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2LVPhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 10:37:10 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:44957 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2LVPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 10:37:07 -0500
From: Marc Dionne <marc.c.dionne@gmail.com>
To: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marc Dionne <marc.c.dionne@gmail.com>
Subject: [PATCH] cred: Remove tgcred pointer from struct cred
Date: Sat, 22 Dec 2012 10:28:43 -0500
Message-Id: <1356190123-11229-1-git-send-email-marc.c.dionne@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3a50597de86 in mainline removed the definition of the
thread_group_cred structure, but left a now unused pointer in
struct cred.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
---
 include/linux/cred.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index abb2cd5..04421e8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -128,7 +128,6 @@ struct cred {
 	struct key	*process_keyring; /* keyring private to this process */
 	struct key	*thread_keyring; /* keyring private to this thread */
 	struct key	*request_key_auth; /* assumed request_key authority */
-	struct thread_group_cred *tgcred; /* thread-group shared credentials */
 #endif
 #ifdef CONFIG_SECURITY
 	void		*security;	/* subjective LSM security */
-- 
1.7.11.7

