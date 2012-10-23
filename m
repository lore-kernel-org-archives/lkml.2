Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab2JWVRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:17:06 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:40896 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab2JWT64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:56 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 09/23] zr36067: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:12 -0300
Message-Id: <1351022246-8201-9-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/pci/zoran/zoran_card.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index fffc54b..cea325d 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -708,8 +708,7 @@ static const struct i2c_algo_bit_data zoran_i2c_bit_data_template = {
 static int
 zoran_register_i2c (struct zoran *zr)
 {
-	memcpy(&zr->i2c_algo, &zoran_i2c_bit_data_template,
-	       sizeof(struct i2c_algo_bit_data));
+	zr->i2c_algo = zoran_i2c_bit_data_template;
 	zr->i2c_algo.data = zr;
 	strlcpy(zr->i2c_adapter.name, ZR_DEVNAME(zr),
 		sizeof(zr->i2c_adapter.name));
-- 
1.7.4.4

