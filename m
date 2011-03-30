Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189Ab1C3VVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:21:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965166Ab1C3VJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133929"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: henry.nestler@gmail.com, lethal@linux-sh.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [230/275] fbcon: Bugfix soft cursor detection in Tile Blitting
Message-Id: <20110330210755.DC59A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/video/console/tileblit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/video/console/tileblit.c
===================================================================
--- linux-2.6.35.y.orig/drivers/video/console/tileblit.c	2011-03-29 22:50:23.367660498 -0700
+++ linux-2.6.35.y/drivers/video/console/tileblit.c	2011-03-29 23:03:03.016222993 -0700
@@ -83,7 +83,7 @@
 			int softback_lines, int fg, int bg)
 {
 	struct fb_tilecursor cursor;
-	int use_sw = (vc->vc_cursor_type & 0x01);
+	int use_sw = (vc->vc_cursor_type & 0x10);
 
 	cursor.sx = vc->vc_x;
 	cursor.sy = vc->vc_y;
