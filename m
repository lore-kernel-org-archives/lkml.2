Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab1CZABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:01:20 -0400
Received: from kroah.org ([198.145.64.141]:48912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab1CYX6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:37 2011
Message-Id: <20110325235637.608416467@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:55:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henry Nestler <henry.nestler@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [11/23] fbcon: Bugfix soft cursor detection in Tile Blitting
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=fbcon-bugfix-soft-cursor-detection-in-tile-blitting.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


