Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1DLO6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:58:00 -0400
Received: from kroah.org ([198.145.64.141]:57414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab1DLOhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:49 2011
Message-Id: <20110412143549.625417852@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [016/105] eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1563,6 +1563,7 @@ int ecryptfs_keyring_auth_tok_for_sig(st
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
 		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+		(*auth_tok_key) = NULL;
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);


