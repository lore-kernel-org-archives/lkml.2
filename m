Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0DOSj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:39:26 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:38263 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0DOSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:39:23 -0400
Date: Thu, 15 Apr 2010 11:38:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-usb@vger.kernel.org,
       gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] usb/serial/ti_usb: fix printk format warning
Message-Id: <20100415113856.45564d4f.randy.dunlap@oracle.com>
In-Reply-To: <20100415144856.659be29e.sfr@canb.auug.org.au>
References: <20100415144856.659be29e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BC75D51.00FD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning in usbserial/ti_usb:

drivers/usb/serial/ti_usb_3410_5052.c:1738: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100415.orig/drivers/usb/serial/ti_usb_3410_5052.c
+++ linux-next-20100415/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1735,7 +1735,7 @@ static int ti_download_firmware(struct t
 		return -ENOENT;
 	}
 	if (fw_p->size > TI_FIRMWARE_BUF_SIZE) {
-		dev_err(&dev->dev, "%s - firmware too large %d \n", __func__, fw_p->size);
+		dev_err(&dev->dev, "%s - firmware too large %zu\n", __func__, fw_p->size);
 		return -ENOENT;
 	}
 
