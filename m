Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1HMOLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:11:54 -0400
Received: from www17.your-server.de ([213.133.104.17]:56300 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HMOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:11:44 -0400
Subject: [PATCH] staging: tidspbridge: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:39:08 +0200
Message-ID: <1313228348.16820.37.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
--- a/drivers/staging/tidspbridge/gen/gh.c 2011-04-14 10:34:38.600880635 +0200
+++ b/drivers/staging/tidspbridge/gen/gh.c 2011-08-01 19:58:07.230403689 +0200
@@ -55,7 +55,7 @@ struct gh_t_hash_tab *gh_create(u16 max_
 	hash_tab->match = match;
 	hash_tab->delete = delete == NULL ? noop : delete;
 
-	hash_tab->buckets = (struct element **)
+	hash_tab->buckets =
 	    kzalloc(sizeof(struct element *) * max_bucket, GFP_KERNEL);
 	if (hash_tab->buckets == NULL) {
 		gh_delete(hash_tab);


