Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1CXUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:32:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56060 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1CXUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:32:54 -0400
Date: Thu, 24 Mar 2011 13:32:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, Mike Waychison <mikew@google.com>
Cc: akpm <akpm@linux-foundation.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: fix nv_tco section mismatch
Message-Id: <20110324133244.acffd99a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D8BAA6F.00DA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:
Mark the called nv_tco_getdevice() as __devinit, just like its caller.

WARNING: drivers/watchdog/nv_tco.o(.devinit.text+0x16): Section mismatch in reference from the function nv_tco_init() to the function .init.text:nv_tco_getdevice()
The function __devinit nv_tco_init() references
a function __init nv_tco_getdevice().
If nv_tco_getdevice is only used by nv_tco_init then
annotate nv_tco_getdevice with a matching annotation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/watchdog/nv_tco.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-git13.orig/drivers/watchdog/nv_tco.c
+++ linux-2.6.38-git13/drivers/watchdog/nv_tco.c
@@ -302,7 +302,7 @@ MODULE_DEVICE_TABLE(pci, tco_pci_tbl);
  *	Init & exit routines
  */
 
-static unsigned char __init nv_tco_getdevice(void)
+static unsigned char __devinit nv_tco_getdevice(void)
 {
 	struct pci_dev *dev = NULL;
 	u32 val;
