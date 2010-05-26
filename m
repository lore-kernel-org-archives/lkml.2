Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0EZRb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:31:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44015 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0EZRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:31:55 -0400
Date: Wed, 26 May 2010 10:30:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       evan_ko@phison.com
Subject: [PATCH -next] staging/phison: depends on ATA_BMDMA
Message-Id: <20100526103002.ac2c6703.randy.dunlap@oracle.com>
In-Reply-To: <20100526153443.f18a4d2b.sfr@canb.auug.org.au>
References: <20100526153443.f18a4d2b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFD5B02.00C4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

phison uses interfaces and data that are built only when
ATA_BMDMA is enabled, so it should depend on that symbol.

drivers/staging/phison/phison.c:43: error: implicit declaration of function 'ATA_BMDMA_SHT'
drivers/staging/phison/phison.c:43: error: initializer element is not constant
drivers/staging/phison/phison.c:43: error: (near initialization for 'phison_sht.module')
drivers/staging/phison/phison.c:47: error: 'ata_bmdma_port_ops' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: evan_ko@phison.com
---
 drivers/staging/phison/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100526.orig/drivers/staging/phison/Kconfig
+++ linux-next-20100526/drivers/staging/phison/Kconfig
@@ -1,5 +1,5 @@
 config IDE_PHISON
 	tristate "PCIE ATA PS5000 IDE support"
-	depends on PCI && ATA && ATA_SFF
+	depends on PCI && ATA && ATA_SFF && ATA_BMDMA
 	---help---
 	  This is an experimental driver for PS5000 IDE driver.
