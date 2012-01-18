Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2ARKEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab2ARKEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:04:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Permit key_serial() to be called with a const key
 pointer
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 18 Jan 2012 10:04:29 +0000
Message-ID: <20120118100429.20605.63305.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit key_serial() to be called with a const key pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index bfc014c..5253471 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -271,7 +271,7 @@ extern int keyring_add_key(struct key *keyring,
 
 extern struct key *key_lookup(key_serial_t id);
 
-static inline key_serial_t key_serial(struct key *key)
+static inline key_serial_t key_serial(const struct key *key)
 {
 	return key ? key->serial : 0;
 }

