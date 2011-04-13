Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab1DMQMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:12:45 -0400
Received: from kroah.org ([198.145.64.141]:52743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647Ab1DMQMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:43 2011
Message-Id: <20110413161043.714452656@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [12/71] eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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


