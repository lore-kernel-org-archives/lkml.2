Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2IQAuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33355 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996Ab2IQAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:29 -0400
Message-Id: <20120917003628.165734909@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 014/135] OMAPFB: fix framebuffer console colors
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit c1c52848cef52e157468b8879fc3cae23b6f3a99 upstream.

omapfb does not currently set pseudo palette correctly for color depths
above 16bpp, making red text invisible, command like
  echo -e '\e[0;31mRED' > /dev/tty1
will display nothing on framebuffer console in 24bpp mode.
This is because temporary variable is declared incorrectly, fix it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/omap2/omapfb/omapfb-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
index 08ec1a7..fc671d3 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1192,7 +1192,7 @@ static int _setcolreg(struct fb_info *fbi, u_int regno, u_int red, u_int green,
 			break;
 
 		if (regno < 16) {
-			u16 pal;
+			u32 pal;
 			pal = ((red >> (16 - var->red.length)) <<
 					var->red.offset) |
 				((green >> (16 - var->green.length)) <<


