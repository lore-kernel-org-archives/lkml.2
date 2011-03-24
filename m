Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278Ab1CXUqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:46:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196Ab1CXUqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CpaIncCUqawkpfUMdAi8d5wWZ2pynZqBZDVOqrm3Y1c6ykxkgclm8a+49q3rb/o66U
         uK3fjT+Gn6CVIQd62054pFw0oxMoGWrrxxc+hcLy80Ea47STxqYBUZ1He2yj2IBfxHyV
         OxeW2hdLgko/bnmYuYO2eO35go0LKmnP1j7lk=
Date: Thu, 24 Mar 2011 22:50:52 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbcon: Remove unused 'display *p' variable from
 fb_flashcursor()
Message-ID: <20110324205052.GA4238@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon: Remove unused 'display *p' variable from fb_flashcursor()

Signed-of-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/video/console/fbcon.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index c583934..8745637 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -370,7 +370,6 @@ static void fb_flashcursor(struct work_struct *work)
 {
 	struct fb_info *info = container_of(work, struct fb_info, queue);
 	struct fbcon_ops *ops = info->fbcon_par;
-	struct display *p;
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
@@ -386,7 +385,6 @@ static void fb_flashcursor(struct work_struct *work)
 		return;
 	}
 
-	p = &fb_display[vc->vc_num];
 	c = scr_readw((u16 *) vc->vc_pos);
 	mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
 		CM_ERASE : CM_DRAW;

