Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0EJRwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:52:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36817 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab0EJRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:52:26 -0400
Date: Mon, 10 May 2010 10:51:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: [PATCH -next] gadget: f_fs.c needs to include pagemap.h
Message-Id: <20100510105136.eee3e58a.randy.dunlap@oracle.com>
In-Reply-To: <20100510160234.54f76c0a.sfr@canb.auug.org.au>
References: <20100510160234.54f76c0a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE847CF.0239:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix g_ffs build error, add a needed header file:

drivers/usb/gadget/f_fs.c:1064:error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c:1065:error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/f_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100510.orig/drivers/usb/gadget/f_fs.c
+++ linux-next-20100510/drivers/usb/gadget/f_fs.c
@@ -28,6 +28,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <asm/unaligned.h>
 #include <linux/smp_lock.h>
 
