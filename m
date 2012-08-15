Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2HOJeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:34:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47449 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HOJeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:34:02 -0400
Date: Wed, 15 Aug 2012 17:33:52 +0800
From: Wang YanQing <udknight@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: [PATCH] video:uvesafb: reduce the double check
Message-ID: <20120815093352.GA32425@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uvesafb_open had checked the par->vbe_state_size,
so we don't need to check it again in uvesafb_vbe_state_save,
this patch just can reduce a few lines of code.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2f8f82d..b064a3e 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -357,9 +357,6 @@ static u8 *uvesafb_vbe_state_save(struct uvesafb_par *par)
 	u8 *state;
 	int err;
 
-	if (!par->vbe_state_size)
-		return NULL;
-
 	state = kmalloc(par->vbe_state_size, GFP_KERNEL);
 	if (!state)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.11.1.116.g8228a23
