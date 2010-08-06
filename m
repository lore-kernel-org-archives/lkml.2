Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638Ab0HFTJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:09:42 -0400
Received: from kroah.org ([198.145.64.141]:58626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965130Ab0HFTAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:36 2010
Message-Id: <20100806185836.185076461@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        David Howells <dhowells@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Michael Neuling <mikey@neuling.org>
Subject: [26/34] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------
 [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition

From: Michael Neuling <mikey@neuling.org>

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This adds the correct header file to fix this.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dns_resolve.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/dns_resolve.h
+++ b/fs/cifs/dns_resolve.h
@@ -24,6 +24,8 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
+#include <linux/module.h>
+
 extern int __init cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);


