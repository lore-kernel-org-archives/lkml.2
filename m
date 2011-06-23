Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab1FWRia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:35499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab1FWRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Henry Nestler <henry.nestler@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 218/247] fbcon: Bugfix soft cursor detection in Tile Blitting
Date: Thu, 23 Jun 2011 13:34:46 -0400
Message-Id: <1308850515-15242-159-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henry Nestler <henry.nestler@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d6244bc0ed0c52a795e6f4dcab3886daf3e74fac upstream.

Use mask 0x10 for "soft cursor" detection on in function tile_cursor.
(Tile Blitting Operation in framebuffer console).

The old mask 0x01 for vc_cursor_type detects CUR_NONE, CUR_LOWER_THIRD
and every second mode value as "software cursor". This hides the cursor
for these modes (cursor.mode = 0). But, only CUR_NONE or "software cursor"
should hide the cursor.
See also 0x10 in functions add_softcursor, bit_cursor and cw_cursor.

Signed-off-by: Henry Nestler <henry.nestler@gmail.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/console/tileblit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/tileblit.c b/drivers/video/console/tileblit.c
index 0056a41..15e8e1a 100644
--- a/drivers/video/console/tileblit.c
+++ b/drivers/video/console/tileblit.c
@@ -83,7 +83,7 @@ static void tile_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 			int softback_lines, int fg, int bg)
 {
 	struct fb_tilecursor cursor;
-	int use_sw = (vc->vc_cursor_type & 0x01);
+	int use_sw = (vc->vc_cursor_type & 0x10);
 
 	cursor.sx = vc->vc_x;
 	cursor.sy = vc->vc_y;
-- 
1.7.4.4

