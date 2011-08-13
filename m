Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1HMOM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:12:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:56453 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1HMOMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:12:09 -0400
Subject: [PATCH] staging: altera-stapl: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:34:09 +0200
Message-ID: <1313228049.16820.32.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/altera-stapl/altera.c b/drivers/staging/altera-stapl/altera.c
--- a/drivers/staging/altera-stapl/altera.c 2011-07-28 15:32:17.809920700 +0200
+++ b/drivers/staging/altera-stapl/altera.c 2011-08-01 19:58:10.467052822 +0200
@@ -2384,7 +2384,7 @@ static int altera_get_act_info(u8 *p,
 		act_proc_attribute =
 			(p[proc_table + (13 * act_proc_id) + 8] & 0x03);
 
-		procptr = (struct altera_procinfo *)
+		procptr =
 				kzalloc(sizeof(struct altera_procinfo),
 								GFP_KERNEL);
 


