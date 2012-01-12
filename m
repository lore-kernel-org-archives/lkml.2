Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2ALVuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:50:04 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54336 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab2ALVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:49:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kernel-janitors@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/media/video/s5p-mfc/s5p_mfc.c: adjust double test
Date: Thu, 12 Jan 2012 22:49:30 +0100
Message-Id: <1326404970-1084-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Rewrite a duplicated test to test the correct value

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There is an img_height field, so it is my guess that that should be tested
instead of testing the img_width field again.

 drivers/media/video/s5p-mfc/s5p_mfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 8be8b54..53126f2 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -475,7 +475,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 			ctx->mv_size = 0;
 		}
 		ctx->dpb_count = s5p_mfc_get_dpb_count();
-		if (ctx->img_width == 0 || ctx->img_width == 0)
+		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
 			ctx->state = MFCINST_HEAD_PARSED;

