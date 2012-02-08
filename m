Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2BHLDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab2BHLDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:03:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/9] KEYS: Announce key type (un)registration
To: steved@redhat.com, jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 Feb 2012 11:03:38 +0000
Message-ID: <20120208110338.4050.92429.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120208110254.4050.8856.stgit@warthog.procyon.org.uk>
References: <20120208110254.4050.8856.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Announce the (un)registration of a key type in the core key code rather than
in the callers.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---

 net/dns_resolver/dns_key.c |    5 -----
 security/keys/key.c        |    3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index c73bba3..14b2c3d 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -249,9 +249,6 @@ static int __init init_dns_resolver(void)
 	struct key *keyring;
 	int ret;
 
-	printk(KERN_NOTICE "Registering the %s key type\n",
-	       key_type_dns_resolver.name);
-
 	/* create an override credential set with a special thread keyring in
 	 * which DNS requests are cached
 	 *
@@ -301,8 +298,6 @@ static void __exit exit_dns_resolver(void)
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
 	put_cred(dns_resolver_cache);
-	printk(KERN_NOTICE "Unregistered %s key type\n",
-	       key_type_dns_resolver.name);
 }
 
 module_init(init_dns_resolver)
diff --git a/security/keys/key.c b/security/keys/key.c
index 7ada801..9173253 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -960,6 +960,8 @@ int register_key_type(struct key_type *ktype)
 
 	/* store the type */
 	list_add(&ktype->link, &key_types_list);
+
+	pr_notice("Key type %s registered\n", ktype->name);
 	ret = 0;
 
 out:
@@ -982,6 +984,7 @@ void unregister_key_type(struct key_type *ktype)
 	list_del_init(&ktype->link);
 	downgrade_write(&key_types_sem);
 	key_gc_keytype(ktype);
+	pr_notice("Key type %s unregistered\n", ktype->name);
 	up_read(&key_types_sem);
 }
 EXPORT_SYMBOL(unregister_key_type);

