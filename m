Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0HCFDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:03:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42808 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0HCFDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:03:05 -0400
From: Michael Neuling <mikey@neuling.org>
To: stable@kernel.org
cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 03 Aug 2010 15:03:03 +1000
Message-ID: <19789.1280811783@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 51c20fcced5badee0e2021c6c89f44aa3cbd72aa

CIFS: Remove __exit mark from cifs_exit_dns_resolver()

Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
module init routine in case of error, and so may have been discarded during
linkage.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: stable@kernel.org (for 2.6.32)
---
This fixes a compile error on ppc64 allmodconfig with 2.6.32.17

fs/cifs/dns_resolve.h:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_exit_dns_resolver

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.c
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.c
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.c
@@ -226,7 +226,7 @@ failed_put_cred:
 	return ret;
 }
 
-void __exit cifs_exit_dns_resolver(void)
+void cifs_exit_dns_resolver(void)
 {
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -25,7 +25,7 @@
 
 #ifdef __KERNEL__
 extern int __init cifs_init_dns_resolver(void);
-extern void __exit cifs_exit_dns_resolver(void);
+extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 
