Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0EQQRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:17:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16391 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0EQQRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:17:09 -0400
Date: Mon, 17 May 2010 09:16:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, linux-pcmcia@lists.infradead.org
Subject: [PATCH -next] pcmciamtd: fix printk format warnings
Message-Id: <20100517091632.59c2696c.randy.dunlap@oracle.com>
In-Reply-To: <20100517163521.649526d0.sfr@canb.auug.org.au>
References: <20100517163521.649526d0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BF16BFE.006E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in pcmciamtd debug code:

drivers/mtd/maps/pcmciamtd.c:163: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c:212: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c:274: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'ssize_t'
drivers/mtd/maps/pcmciamtd.c:312: warning: format '%u' expects type 'unsigned int', but argument 5 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/maps/pcmciamtd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20100517.orig/drivers/mtd/maps/pcmciamtd.c
+++ linux-next-20100517/drivers/mtd/maps/pcmciamtd.c
@@ -160,7 +160,7 @@ static void pcmcia_copy_from_remap(struc
 	struct pcmciamtd_dev *dev = (struct pcmciamtd_dev *)map->map_priv_1;
 	unsigned long win_size = dev->win_size;
 
-	DEBUG(3, "to = %p from = %lu len = %u", to, from, len);
+	DEBUG(3, "to = %p from = %lu len = %zd", to, from, len);
 	while(len) {
 		int toread = win_size - (from & (win_size-1));
 		caddr_t addr;
@@ -209,7 +209,7 @@ static void pcmcia_copy_to_remap(struct 
 	struct pcmciamtd_dev *dev = (struct pcmciamtd_dev *)map->map_priv_1;
 	unsigned long win_size = dev->win_size;
 
-	DEBUG(3, "to = %lu from = %p len = %u", to, from, len);
+	DEBUG(3, "to = %lu from = %p len = %zd", to, from, len);
 	while(len) {
 		int towrite = win_size - (to & (win_size-1));
 		caddr_t addr;
@@ -271,7 +271,7 @@ static void pcmcia_copy_from(struct map_
 	if(DEV_REMOVED(map))
 		return;
 
-	DEBUG(3, "to = %p from = %lu len = %u", to, from, len);
+	DEBUG(3, "to = %p from = %lu len = %zd", to, from, len);
 	memcpy_fromio(to, win_base + from, len);
 }
 
@@ -309,7 +309,7 @@ static void pcmcia_copy_to(struct map_in
 	if(DEV_REMOVED(map))
 		return;
 
-	DEBUG(3, "to = %lu from = %p len = %u", to, from, len);
+	DEBUG(3, "to = %lu from = %p len = %zd", to, from, len);
 	memcpy_toio(win_base + to, from, len);
 }
 
