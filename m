Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0KMQpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:45:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33197 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab0KMQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:45:27 -0500
Date: Sat, 13 Nov 2010 08:44:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
        Tony Finch <dot@dotat.at>
Subject: [PATCH -next] xen: fix header export to userspace
Message-Id: <20101113084439.d21bd0f0.randy.dunlap@oracle.com>
In-Reply-To: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/headers_install.pl prevents "__user" from being exported
to userspace headers, so just use compiler.h to make sure that
__user is defined and avoid the error.

unifdef: linux-next-20101112/xx64/usr/include/xen/privcmd.h.tmp: 79: Premature EOF (#if line 33 depth 1)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:	xen-devel@lists.xensource.com (moderated for non-subscribers)
Cc:	virtualization@lists.osdl.org
Cc:	Tony Finch <dot@dotat.at>
---
 include/xen/privcmd.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-next-20101112.orig/include/xen/privcmd.h
+++ linux-next-20101112/include/xen/privcmd.h
@@ -34,13 +34,10 @@
 #define __LINUX_PUBLIC_PRIVCMD_H__
 
 #include <linux/types.h>
+#include <linux/compiler.h>
 
 typedef unsigned long xen_pfn_t;
 
-#ifndef __user
-#define __user
-#endif
-
 struct privcmd_hypercall {
 	__u64 op;
 	__u64 arg[5];
