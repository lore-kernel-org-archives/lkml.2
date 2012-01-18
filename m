Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2ARKDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab2ARKDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:03:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] keys: fix user_defined key sparse messages
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>
Date: Wed, 18 Jan 2012 10:03:14 +0000
Message-ID: <20120118100314.20452.87629.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Replace the rcu_assign_pointer() calls with rcu_assign_keypointer().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/user_defined.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 69ff52c..2aee3c5 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -59,7 +59,7 @@ int user_instantiate(struct key *key, const void *data, size_t datalen)
 	/* attach the data */
 	upayload->datalen = datalen;
 	memcpy(upayload->data, data, datalen);
-	rcu_assign_pointer(key->payload.data, upayload);
+	rcu_assign_keypointer(key, upayload);
 	ret = 0;
 
 error:
@@ -98,7 +98,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 	if (ret == 0) {
 		/* attach the new data, displacing the old */
 		zap = key->payload.data;
-		rcu_assign_pointer(key->payload.data, upayload);
+		rcu_assign_keypointer(key, upayload);
 		key->expiry = 0;
 	}
 
@@ -133,7 +133,7 @@ void user_revoke(struct key *key)
 	key_payload_reserve(key, 0);
 
 	if (upayload) {
-		rcu_assign_pointer(key->payload.data, NULL);
+		rcu_assign_keypointer(key, NULL);
 		kfree_rcu(upayload, rcu);
 	}
 }

