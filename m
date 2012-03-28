Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2C1KrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab2C1KrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:47:01 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/9] KEYS: Announce key type (un)registration
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@us.ibm.com>
Date: Wed, 28 Mar 2012 11:46:52 +0100
Message-ID: <20120328104652.10417.86751.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
References: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
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
index 06783cf..dc62894 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -980,6 +980,8 @@ int register_key_type(struct key_type *ktype)
 
 	/* store the type */
 	list_add(&ktype->link, &key_types_list);
+
+	pr_notice("Key type %s registered\n", ktype->name);
 	ret = 0;
 
 out:
@@ -1002,6 +1004,7 @@ void unregister_key_type(struct key_type *ktype)
 	list_del_init(&ktype->link);
 	downgrade_write(&key_types_sem);
 	key_gc_keytype(ktype);
+	pr_notice("Key type %s unregistered\n", ktype->name);
 	up_read(&key_types_sem);
 }
 EXPORT_SYMBOL(unregister_key_type);

