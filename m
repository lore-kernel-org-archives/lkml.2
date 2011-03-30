Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301Ab1C3VKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:38679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965272Ab1C3VKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448770"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: roberto.sassu@polito.it, tyhicks@linux.vnet.ibm.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [253/275] eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
Message-Id: <20110330210820.132473E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Roberto Sassu <roberto.sassu@polito.it>

commit 1821df040ac3cd6a57518739f345da6d50ea9d3f upstream.

The pointer '(*auth_tok_key)' is set to NULL in case request_key()
fails, in order to prevent its use by functions calling
ecryptfs_keyring_auth_tok_for_sig().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ecryptfs/keystore.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/fs/ecryptfs/keystore.c
===================================================================
--- linux-2.6.35.y.orig/fs/ecryptfs/keystore.c	2011-03-29 22:50:09.722009658 -0700
+++ linux-2.6.35.y/fs/ecryptfs/keystore.c	2011-03-29 23:03:03.535209714 -0700
@@ -1543,6 +1543,7 @@
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
 		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+		(*auth_tok_key) = NULL;
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
