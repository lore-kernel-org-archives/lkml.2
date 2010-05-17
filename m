Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0EQNnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0EQNnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:43:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Return more accurate error codes
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: jmorris@namei.org, oleg@redhat.com, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, David Howells <dhowells@redhat.com>
Date: Mon, 17 May 2010 14:42:35 +0100
Message-ID: <20100517134235.19013.90388.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

We were using the wrong variable here so the error codes weren't being returned
properly.  The original code returns -ENOKEY.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/process_keys.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 06c2ccf..20a38fe 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -508,7 +508,7 @@ try_again:
 
 			ret = install_thread_keyring();
 			if (ret < 0) {
-				key = ERR_PTR(ret);
+				key_ref = ERR_PTR(ret);
 				goto error;
 			}
 			goto reget_creds;
@@ -526,7 +526,7 @@ try_again:
 
 			ret = install_process_keyring();
 			if (ret < 0) {
-				key = ERR_PTR(ret);
+				key_ref = ERR_PTR(ret);
 				goto error;
 			}
 			goto reget_creds;
@@ -585,7 +585,7 @@ try_again:
 
 	case KEY_SPEC_GROUP_KEYRING:
 		/* group keyrings are not yet supported */
-		key = ERR_PTR(-EINVAL);
+		key_ref = ERR_PTR(-EINVAL);
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:

