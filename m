Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1HJSWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:22:45 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44982 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754286Ab1HJSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:22:44 -0400
Date: Wed, 10 Aug 2011 11:22:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, xen-devel@lists.xensource.com
Subject: [PATCH mainline] xen: xen-selfballoon.c needs more header files
Message-Id: <20110810112242.18b743de.rdunlap@xenotime.net>
In-Reply-To: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors (found when CONFIG_SYSFS is not enabled):

drivers/xen/xen-selfballoon.c:446: warning: data definition has no type or storage class
drivers/xen/xen-selfballoon.c:446: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
drivers/xen/xen-selfballoon.c:446: warning: parameter names (without types) in function declaration
drivers/xen/xen-selfballoon.c:485: error: expected declaration specifiers or '...' before string constant
drivers/xen/xen-selfballoon.c:485: warning: data definition has no type or storage class
drivers/xen/xen-selfballoon.c:485: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/xen/xen-selfballoon.c:485: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/xen/xen-selfballoon.c |    1 +
 1 file changed, 1 insertion(+)

and will need <linux/export.h> when module.h is split up.

--- lnx-31-rc1.orig/drivers/xen/xen-selfballoon.c
+++ lnx-31-rc1/drivers/xen/xen-selfballoon.c
@@ -70,6 +70,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/module.h>
 #include <linux/workqueue.h>
 #include <xen/balloon.h>
 #include <xen/tmem.h>
