Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1ABHVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:33955 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ABHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 002/260] KEYS: Return more accurate error codes
Date: Sun,  2 Jan 2011 02:14:58 -0500
Message-Id: <1293952756-15010-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:09.0131 (UTC) FILETIME=[7CB017B0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 4d09ec0f705cf88a12add029c058b53f288cfaa2 upstream.

We were using the wrong variable here so the error codes weren't being returned
properly.  The original code returns -ENOKEY.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
-- 
1.7.3.3

