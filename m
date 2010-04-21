Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0DUVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:33:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65140 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0DUVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:33:50 -0400
Date: Wed, 21 Apr 2010 14:32:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Scott Smedley <ss@aao.gov.au>
Subject: [PATCH resend] staging: fix dt3155 build
Message-Id: <20100421143247.eb7e9f39.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1004191633050.9086@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004191633050.9086@i5.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BCF6F2F.024A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When the dt3155 driver is built-in (not as a loadable module),
these build errors happen:

drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration of function 'request_irq'
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED' undeclared (first use in this function)
drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration of function 'free_irq'

so remove the #ifdef MODULE check since it's not needed.
Also remove the CONFIG_PCI check since the Kconfig file already
requires that.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Scott Smedley <ss@aao.gov.au>
Tested-by: Jan III Sobieski <jan3sobi3ski@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- lnx-2634-rc5.orig/drivers/staging/dt3155/dt3155_drv.c
+++ lnx-2634-rc5/drivers/staging/dt3155/dt3155_drv.c
@@ -57,19 +57,8 @@ MA 02111-1307 USA
 
 extern void printques(int);
 
-#ifdef MODULE
 #include <linux/module.h>
 #include <linux/interrupt.h>
-
-
-MODULE_LICENSE("GPL");
-
-#endif
-
-#ifndef CONFIG_PCI
-#error  "DT3155 :  Kernel PCI support not enabled (DT3155 drive requires PCI)"
-#endif
-
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/poll.h>
@@ -84,6 +73,9 @@ MODULE_LICENSE("GPL");
 #include "dt3155_io.h"
 #include "allocator.h"
 
+
+MODULE_LICENSE("GPL");
+
 /* Error variable.  Zero means no error. */
 int dt3155_errno = 0;
 
