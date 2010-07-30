Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0G3O0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab0G3OZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:25:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>
Date: Fri, 30 Jul 2010 15:25:19 +0100
Message-ID: <20100730142519.18287.22053.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
module init routine in case of error, and so may have been discarded during
linkage.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
---

 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/dns_resolve.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 49315cb..853a968 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -227,7 +227,7 @@ failed_put_cred:
 	return ret;
 }
 
-void __exit cifs_exit_dns_resolver(void)
+void cifs_exit_dns_resolver(void)
 {
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
index 26b9eaa..5d7f291 100644
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -25,7 +25,7 @@
 
 #ifdef __KERNEL__
 extern int __init cifs_init_dns_resolver(void);
-extern void __exit cifs_exit_dns_resolver(void);
+extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 

