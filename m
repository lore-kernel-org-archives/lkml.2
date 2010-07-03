Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0GCB0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 21:26:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65106 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0GCB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 21:26:09 -0400
Date: Fri, 2 Jul 2010 18:24:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Samium Gromoff <_deepfire@feelingofgreen.ru>,
       Greg KH <greg@kroah.com>
Subject: [PATCH -mmotm] 8250_early: fix printk format warnings
Message-Id: <20100702182437.977c8ef8.randy.dunlap@oracle.com>
In-Reply-To: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C2E9185.00CA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:

drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Greg KH <greg@kroah.com>
---
 drivers/serial/8250_early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2010-0701-1219.orig/drivers/serial/8250_early.c
+++ mmotm-2010-0701-1219/drivers/serial/8250_early.c
@@ -202,12 +202,12 @@ static int __init parse_options(struct e
 	}
 
 	if (mmio || mmio32)
-		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
+		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
 		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
 		       device->options);
 	else
 		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
-		       (unsigned long long) port->iobase, device->options);
+		       (void *) port->iobase, device->options);
 
 	return 0;
 }
