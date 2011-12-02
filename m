Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1LBSnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:43:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab1LBSnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:39 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/21] KEYS: Announce key type (un)registration [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:43:30 +0000
Message-ID: <20111202184329.21874.76730.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
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
---

 net/dns_resolver/dns_key.c |    5 -----
 security/keys/key.c        |    3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index fa000d2..689d7c8 100644
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
@@ -300,8 +297,6 @@ static void __exit exit_dns_resolver(void)
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
 	put_cred(dns_resolver_cache);
-	printk(KERN_NOTICE "Unregistered %s key type\n",
-	       key_type_dns_resolver.name);
 }
 
 module_init(init_dns_resolver)
diff --git a/security/keys/key.c b/security/keys/key.c
index 4414abd..a8086a1 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -957,6 +957,8 @@ int register_key_type(struct key_type *ktype)
 
 	/* store the type */
 	list_add(&ktype->link, &key_types_list);
+
+	pr_notice("Key type %s registered\n", ktype->name);
 	ret = 0;
 
 out:
@@ -979,6 +981,7 @@ void unregister_key_type(struct key_type *ktype)
 	list_del_init(&ktype->link);
 	downgrade_write(&key_types_sem);
 	key_gc_keytype(ktype);
+	pr_notice("Key type %s unregistered\n", ktype->name);
 	up_read(&key_types_sem);
 }
 EXPORT_SYMBOL(unregister_key_type);

