Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1AXPh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:37:26 -0500
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:51175 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752763Ab1AXPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:37:25 -0500
Subject: [PATCH] security: keyring: remove redundant NULL check
From: Davidlohr Bueso <dave@gnu.org>
To: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Cc: keyrings@linux-nfs.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:37:17 -0300
Message-ID: <1295883437.2156.1.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>
Date: Sun, 23 Jan 2011 22:01:20 -0300

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 security/keys/keyring.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index d37f713..cb8110b 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -866,11 +866,10 @@ void __key_link_end(struct key *keyring, struct key_type *type,
 	if (type == &key_type_keyring)
 		up_write(&keyring_serialise_link_sem);
 
-	if (prealloc) {
-		kfree(prealloc);
-		key_payload_reserve(keyring,
-				    keyring->datalen - KEYQUOTA_LINK_BYTES);
-	}
+	kfree(prealloc);
+	key_payload_reserve(keyring,
+			keyring->datalen - KEYQUOTA_LINK_BYTES);
+
 	up_write(&keyring->sem);
 }
 
-- 
1.7.1



