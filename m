Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DZJzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:55:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56062
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab0DZJzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:55:38 -0400
Date: Mon, 26 Apr 2010 02:55:42 -0700 (PDT)
Message-Id: <20100426.025542.193706542.davem@davemloft.net>
To: airlied@redhat.com
CC: suokkos@gmail.com, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon: Fix sparc regression in r300_scratch()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit b4fe945405e477cded91772b4fec854705443dd5 ("drm/radeon: Fix
memory allocation failures in the preKMS command stream checking.")
added a regression in that it completely tossed the get_unaligned()
done by r300_scratch() which we added in commit
958a6f8ccb1964adc3eec84cf401c5baeb4fbca0 ("drm: radeon: Fix unaligned
access in r300_scratch().").

Put it back.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index ea46d55..c5c2742 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -921,7 +921,7 @@ static int r300_scratch(drm_radeon_private_t *dev_priv,
 
 	ptr_addr = drm_buffer_read_object(cmdbuf->buffer,
 			sizeof(stack_ptr_addr), &stack_ptr_addr);
-	ref_age_base = (u32 *)(unsigned long)*ptr_addr;
+	ref_age_base = (u32 *)(unsigned long)get_unaligned(ptr_addr);
 
 	for (i=0; i < header.scratch.n_bufs; i++) {
 		buf_idx = drm_buffer_pointer_to_dword(cmdbuf->buffer, 0);
