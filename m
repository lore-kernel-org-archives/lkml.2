Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1HMOMC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:12:02 -0400
Received: from www17.your-server.de ([213.133.104.17]:56375 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1HMOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:11:56 -0400
Subject: [PATCH] Staging: rts_pstor: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:28:50 +0200
Message-ID: <1313227730.16820.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rts_pstor/spi.c b/drivers/staging/rts_pstor/spi.c
--- a/drivers/staging/rts_pstor/spi.c 2011-05-27 19:17:05.999541117 +0200
+++ b/drivers/staging/rts_pstor/spi.c 2011-08-01 19:57:11.534038755 +0200
@@ -463,7 +463,7 @@ int spi_read_flash_id(struct scsi_cmnd *
 	}
 
 	if (len) {
-		buf = (u8 *)kmalloc(len, GFP_KERNEL);
+		buf = kmalloc(len, GFP_KERNEL);
 		if (!buf)
 			TRACE_RET(chip, STATUS_ERROR);
 


