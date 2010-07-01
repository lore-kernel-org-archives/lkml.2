Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0GASLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:11:12 -0400
Received: from kroah.org ([198.145.64.141]:60123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0GASK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:58 2010
Message-Id: <20100701172858.213606614@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:27:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: [21/23] KEYS: Return more accurate error codes
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 4d09ec0f705cf88a12add029c058b53f288cfaa2 upstream.

We were using the wrong variable here so the error codes weren't being returned
properly.  The original code returns -ENOKEY.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


