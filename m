Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1DYU17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:27:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34672 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab1DYU15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:27:57 -0400
Message-Id: <20110425200238.209377778@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 120/173] eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roberto Sassu <roberto.sassu@polito.it>

commit 1821df040ac3cd6a57518739f345da6d50ea9d3f upstream.

The pointer '(*auth_tok_key)' is set to NULL in case request_key()
fails, in order to prevent its use by functions calling
ecryptfs_keyring_auth_tok_for_sig().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1542,6 +1542,7 @@ int ecryptfs_keyring_auth_tok_for_sig(st
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
 		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+		(*auth_tok_key) = NULL;
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);


