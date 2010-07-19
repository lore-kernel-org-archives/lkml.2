Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966915Ab0GSVlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:41:22 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40074 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966879Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213854.101237411@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:36 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 18/25] GRU - contexts must contain cbrs
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_cbr_check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Don't allow users to create GRU contexts with 0 CBRs. This does
not make sense & is not allowed by the chiplet. The chiplet will flag this
as an error and fail to allocate the context.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:46.261068458 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:47.151963284 -0500
@@ -175,7 +175,7 @@ static int gru_create_new_context(unsign
 
 	if (req.data_segment_bytes > max_user_dsr_bytes)
 		return -EINVAL;
-	if (req.control_blocks > max_user_cbrs || !req.maximum_thread_count)
+	if (req.control_blocks == 0 || req.control_blocks > max_user_cbrs || !req.maximum_thread_count)
 		return -EINVAL;
 
 	if (!(req.options & GRU_OPT_MISS_MASK))

