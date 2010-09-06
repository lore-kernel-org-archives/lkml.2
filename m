Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0IFOhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:37:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33623 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab0IFOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:55 -0400
Date: Mon, 6 Sep 2010 16:36:53 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 11/14] drivers/video: Removing undead ifdef
 CONFIG_FB_MATROX_G
Message-ID: <28eb44049d7ab968bd9c820f65595af79dee5688.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_FB_MATROX_G ifdef isn't necessary at this point, because it
is checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/video/matrox/matroxfb_DAC1064.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index f9fa0fd..1717623 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -869,12 +869,9 @@ static int MGAG100_preinit(struct matrox_fb_info *minfo)
 	minfo->capable.plnwt = minfo->devflags.accelerator == FB_ACCEL_MATROX_MGAG100
 			? minfo->devflags.sgram : 1;
 
-#ifdef CONFIG_FB_MATROX_G
 	if (minfo->devflags.g450dac) {
 		minfo->outputs[0].output = &g450out;
-	} else
-#endif
-	{
+	} else {
 		minfo->outputs[0].output = &m1064;
 	}
 	minfo->outputs[0].src = minfo->outputs[0].default_src;
-- 
1.7.0.4

