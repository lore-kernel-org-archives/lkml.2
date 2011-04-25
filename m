Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1DYUom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34320 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab1DYUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:48 -0400
Message-Id: <20110425200237.687004763@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Henry Nestler <henry.nestler@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 108/173] fbcon: Bugfix soft cursor detection in Tile Blitting
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henry Nestler <henry.nestler@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/console/tileblit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/console/tileblit.c
+++ b/drivers/video/console/tileblit.c
@@ -83,7 +83,7 @@ static void tile_cursor(struct vc_data *
 			int softback_lines, int fg, int bg)
 {
 	struct fb_tilecursor cursor;
-	int use_sw = (vc->vc_cursor_type & 0x01);
+	int use_sw = (vc->vc_cursor_type & 0x10);
 
 	cursor.sx = vc->vc_x;
 	cursor.sy = vc->vc_y;


