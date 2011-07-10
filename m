Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1GJSoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:44:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37389 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1GJSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:44:19 -0400
Date: Sun, 10 Jul 2011 11:44:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mmotm] misc: fix eeprom printk format
Message-Id: <20110710114403.b14120eb.randy.dunlap@oracle.com>
In-Reply-To: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E19F2FF.0065:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/misc/eeprom/eeprom_93xx46.c:95: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anatolij Gustschin <agust@denx.de>
applies-to: misc-eeprom-add-driver-for-microwire-93xx46-eeproms.patch
---
 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2011-0708-1250.orig/drivers/misc/eeprom/eeprom_93xx46.c
+++ mmotm-2011-0708-1250/drivers/misc/eeprom/eeprom_93xx46.c
@@ -91,7 +91,7 @@ eeprom_93xx46_bin_read(struct file *filp
 	/* have to wait at least Tcsl ns */
 	ndelay(250);
 	if (ret) {
-		dev_err(&edev->spi->dev, "read %d bytes at %d: err. %d\n",
+		dev_err(&edev->spi->dev, "read %zu bytes at %d: err. %d\n",
 			count, (int)off, ret);
 	}
 
