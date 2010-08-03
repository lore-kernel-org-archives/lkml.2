Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0HCFDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:03:44 -0400
Received: from ozlabs.org ([203.10.76.45]:42893 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0HCFDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:03:43 -0400
From: Michael Neuling <mikey@neuling.org>
To: stable@kernel.org
cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH 2.6.32/stable] CIFS: Remove __exit mark from cifs_init_dns_resolver() header
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
References: <19789.1280811783@neuling.org>
Date: Tue, 03 Aug 2010 15:03:41 +1000
Message-ID: <19826.1280811821@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This removes the __init from cifs_init_dns_resolver()

Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: stable@kernel.org (for 2.6.32)

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -24,7 +24,7 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
-extern int __init cifs_init_dns_resolver(void);
+extern int cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
