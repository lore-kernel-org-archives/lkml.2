Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0CYSa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:30:58 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:40104 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0CYSa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:30:56 -0400
Message-ID: <4BABAB7C.5000006@oracle.com>
Date: Thu, 25 Mar 2010 11:29:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: [PATCH 2/3 -next] usb: fix serial build when SYSRQ is disabled
References: <20100325173853.f06a7b33.sfr@canb.auug.org.au>
In-Reply-To: <20100325173853.f06a7b33.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BABABCF.006B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:

drivers/usb/serial/generic.c:566: error: implicit declaration of function 'handle_sysrq'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/serial/generic.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-next-20100325.orig/drivers/usb/serial/generic.c
+++ linux-next-20100325/drivers/usb/serial/generic.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/sysrq.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
@@ -558,6 +559,7 @@ void usb_serial_generic_unthrottle(struc
 	}
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ
 int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 			struct usb_serial_port *port, unsigned int ch)
 {
@@ -571,6 +573,13 @@ int usb_serial_handle_sysrq_char(struct 
 	}
 	return 0;
 }
+#else
+int usb_serial_handle_sysrq_char(struct tty_struct *tty,
+			struct usb_serial_port *port, unsigned int ch)
+{
+	return 0;
+}
+#endif
 EXPORT_SYMBOL_GPL(usb_serial_handle_sysrq_char);
 
 int usb_serial_handle_break(struct usb_serial_port *port)
