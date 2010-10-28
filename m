Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab0J1Ml0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:41:26 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:52586 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324Ab0J1MlY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:41:24 -0400
Subject: [PATCH] atyfb: fix build regression
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 09:41:13 -0300
Message-ID: <1288269673.2212.9.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>
Date: Thu, 28 Oct 2010 09:32:44 -0300
Subject: [PATCH 6/6] atyfb: fix build regression

On Today's randconfig the following is happening on Linus' latest tree:

  CC      drivers/video/aty/atyfb_base.o
drivers/video/aty/atyfb_base.c:553: error: ‘ram_dram’ undeclared here (not in a function)
drivers/video/aty/atyfb_base.c:554: error: ‘ram_resv’ undeclared here (not in a function)
make[3]: *** [drivers/video/aty/atyfb_base.o] Error 1
make[2]: *** [drivers/video/aty] Error 2
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

I believe that th ram_dram and ram_resv where removed based on this http://lkml.org/lkml/2010/9/22/258

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/video/aty/atyfb_base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 8e58f4a..5988b88 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -535,6 +535,8 @@ static int __devinit correct_chipset(struct atyfb_par *par)
 	return 0;
 }
 
+static char ram_dram[] __devinitdata = "DRAM";
+static char ram_resv[] __devinitdata = "RESV";
 #ifdef CONFIG_FB_ATY_GX
 static char ram_vram[] __devinitdata = "VRAM";
 #endif /* CONFIG_FB_ATY_GX */
-- 
1.7.0.4



