Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1HMOOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:14:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:57351 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HMOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:14:44 -0400
Subject: [PATCH] staging: rts_pstor: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Aug 2011 16:14:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313244847.16820.43.camel@localhost.localdomain>
Mime-Version: 1.0
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

diff -u -p a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
--- a/drivers/staging/rts_pstor/sd.c 2011-07-28 15:32:18.233251740 +0200
+++ b/drivers/staging/rts_pstor/sd.c 2011-08-01 19:57:13.347362265 +0200
@@ -4139,7 +4139,7 @@ int sd_execute_read_data(struct scsi_cmn
 		cmd[3] = srb->cmnd[5];
 		cmd[4] = srb->cmnd[6];
 
-		buf = (u8 *)kmalloc(data_len, GFP_KERNEL);
+		buf = kmalloc(data_len, GFP_KERNEL);
 		if (buf == NULL) {
 			TRACE_RET(chip, TRANSPORT_ERROR);
 		}
@@ -4385,7 +4385,7 @@ int sd_execute_write_data(struct scsi_cm
 		u16 i;
 		u8 *buf;
 
-		buf = (u8 *)kmalloc(data_len, GFP_KERNEL);
+		buf = kmalloc(data_len, GFP_KERNEL);
 		if (buf == NULL) {
 			TRACE_RET(chip, TRANSPORT_ERROR);
 		}



