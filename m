Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab2JWUDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:03:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62157 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab2JWT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:06 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 13/23] tuners/xc2028: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:16 -0300
Message-Id: <1351022246-8201-13-git-send-email-elezegarcia@gmail.com>
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
 drivers/media/tuners/tuner-xc2028.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 7bcb6b0..0945173 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -870,7 +870,7 @@ check_device:
 	}
 
 read_not_reliable:
-	memcpy(&priv->cur_fw, &new_fw, sizeof(priv->cur_fw));
+	priv->cur_fw = new_fw;
 
 	/*
 	 * By setting BASE in cur_fw.type only after successfully loading all
-- 
1.7.4.4

