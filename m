Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0HCWcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:32:17 -0400
Received: from ozlabs.org ([203.10.76.45]:53019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0HCWcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:32:15 -0400
From: Michael Neuling <mikey@neuling.org>
To: David Howells <dhowells@redhat.com>
cc: stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
In-reply-to: <12482.1280871625@redhat.com>
References: <19826.1280811821@neuling.org> <19789.1280811783@neuling.org> <12482.1280871625@redhat.com>
Comments: In-reply-to David Howells <dhowells@redhat.com>
   message dated "Tue, 03 Aug 2010 22:40:25 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 04 Aug 2010 08:32:13 +1000
Message-ID: <20749.1280874733@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <12482.1280871625@redhat.com> you wrote:
> Michael Neuling <mikey@neuling.org> wrote:
> 
> > An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> > 
> > fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attrib
ute__' before 'cifs_init_dns_resolver'
> > 
> > This removes the __init from cifs_init_dns_resolver()
> 
> That's not really a good idea as the assembler may choose different pieces of
> assembly to do variable references and jumps, depending on the section
> information.
> 
> A better fix is to add:
> 
> 	#include <linux/module.h>
> 
> to the header file.

Ok, new patch below.



CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition

An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error

fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'

This adds the correct header file to fix this. 

Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: stable@kernel.org (for 2.6.32)

Index: linux-2.6-ozlabs/fs/cifs/dns_resolve.h
===================================================================
--- linux-2.6-ozlabs.orig/fs/cifs/dns_resolve.h
+++ linux-2.6-ozlabs/fs/cifs/dns_resolve.h
@@ -24,6 +24,8 @@
 #define _DNS_RESOLVE_H
 
 #ifdef __KERNEL__
+#include <linux/module.h>
+
 extern int __init cifs_init_dns_resolver(void);
 extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
