Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1HMOLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:11:42 -0400
Received: from www17.your-server.de ([213.133.104.17]:56273 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HMOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:11:41 -0400
Subject: [PATCH] staging: rts_pstor: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:27:10 +0200
Message-ID: <1313227631.16820.25.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/rts_pstor/rtsx_scsi.c b/drivers/staging/rts_pstor/rtsx_scsi.c
--- a/drivers/staging/rts_pstor/rtsx_scsi.c 2011-05-05 20:48:37.168211054 +0200
+++ b/drivers/staging/rts_pstor/rtsx_scsi.c 2011-08-01 19:57:16.027347746 +0200
@@ -2730,7 +2730,7 @@ static int get_ms_information(struct scs
 		buf_len = data_len = 0x6A;
 	}
 
-	buf = (u8 *)kmalloc(buf_len, GFP_KERNEL);
+	buf = kmalloc(buf_len, GFP_KERNEL);
 	if (!buf) {
 		TRACE_RET(chip, TRANSPORT_ERROR);
 	}


