Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab0LUBly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:41:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab0LUBlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:41:52 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 1/3] fb: fix overlapping test off-by-one.
Date: Tue, 21 Dec 2010 11:41:15 +1000
Message-Id: <1292895677-4242-2-git-send-email-airlied@gmail.com>
In-Reply-To: <1292895677-4242-1-git-send-email-airlied@gmail.com>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

On my system with a radeon x2, the first GPU was not overlapping vesa
but the test decided it was.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/video/fbmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0e6aa3d..4ac1201 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1458,7 +1458,7 @@ static bool apertures_overlap(struct aperture *gen, struct aperture *hw)
 	if (gen->base == hw->base)
 		return true;
 	/* is the generic aperture base inside the hw base->hw base+size */
-	if (gen->base > hw->base && gen->base <= hw->base + hw->size)
+	if (gen->base > hw->base && gen->base < hw->base + hw->size)
 		return true;
 	return false;
 }
-- 
1.7.1

