Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579Ab0HFTKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:10:06 -0400
Received: from kroah.org ([198.145.64.141]:58618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965121Ab0HFTAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:36 2010
Message-Id: <20100806185836.090319020@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Michael Neuling <mikey@neuling.org>
Subject: [25/34] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 51c20fcced5badee0e2021c6c89f44aa3cbd72aa upstream.

Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
module init routine in case of error, and so may have been discarded during
linkage.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/dns_resolve.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -226,7 +226,7 @@ failed_put_cred:
 	return ret;
 }
 
-void __exit cifs_exit_dns_resolver(void)
+void cifs_exit_dns_resolver(void)
 {
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -25,7 +25,7 @@
 
 #ifdef __KERNEL__
 extern int __init cifs_init_dns_resolver(void);
-extern void __exit cifs_exit_dns_resolver(void);
+extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 


