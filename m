Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0IHVUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:20:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36037 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0IHVUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AmV8Yxg5sxkgdJaVb4/exmysgymLEx8v+J7Ds2bcnGVRQDxTjw8YDhbM7zk+w/VZsP
         TbJqb4Z/y71+Cg3+zT/oegvAzMxYrK1h6FkUkb1BKINke8OpGum+tECL1D8VZJ7o6W5s
         vT9SmqYO7pI6MDf5o8Mg1Uu8Rv96yi5Lzpe4g=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: eilong@broadcom.com, davem@davemloft.net, dmitry@broadcom.com,
        yanivr@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 5/8] drivers/net/bnx2x: use ARRAY_SIZE macro in bnx2x_main.c
Date: Wed,  8 Sep 2010 22:20:37 +0100
Message-Id: <1283980837-5025-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(bnx2x_parity_mask)/(sizeof(bnx2x_parity_mask[0]) with
ARRAY_SIZE(bnx2x_parity_mask) in drivers/net/bnx2x/bnx2x_main.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 drivers/net/bnx2x/bnx2x_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index f8c3f08..e534ae8 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -3803,10 +3803,9 @@ static const struct {
 
 static void enable_blocks_parity(struct bnx2x *bp)
 {
-	int i, mask_arr_len =
-		sizeof(bnx2x_parity_mask)/(sizeof(bnx2x_parity_mask[0]));
+	int i;
 
-	for (i = 0; i < mask_arr_len; i++)
+	for (i = 0; i < ARRAY_SIZE(bnx2x_parity_mask); i++)
 		REG_WR(bp, bnx2x_parity_mask[i].addr,
 			bnx2x_parity_mask[i].mask);
 }
-- 
1.7.2.3

