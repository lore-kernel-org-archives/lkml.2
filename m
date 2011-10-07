Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335Ab1JGU7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:59:44 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38370 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754321Ab1JGU7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:59:43 -0400
Message-ID: <4E8F683D.9020604@xenotime.net>
Date: Fri, 07 Oct 2011 13:59:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
In-Reply-To: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Add <linux/stat.h> to fix build errors:

drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: 'S_IRUGO' undeclared here (not in a function)
drivers/infiniband/hw/ipath/ipath_init_chip.c:54:1: error: bit-field '<anonymous>' width not an integer constant
drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: 'S_IWUSR' undeclared here (not in a function)
drivers/infiniband/hw/ipath/ipath_init_chip.c:67:1: error: bit-field '<anonymous>' width not an integer constant

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Mike Marciniszyn <infinipath@qlogic.com>
Cc:	linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    1 +
 1 file changed, 1 insertion(+)

--- next-2011-1007.orig/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ next-2011-1007/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -35,6 +35,7 @@
 #include <linux/netdevice.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 #include <linux/vmalloc.h>
 
 #include "ipath_kernel.h"
