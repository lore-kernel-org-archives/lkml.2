Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab0IXTWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:22:19 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:47201 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757855Ab0IXTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:22:15 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Maik Broemme <mbroemme@plusserver.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/24] video: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:34 -0700
Message-Id: <a46ccb29d75d29ec20a10c9a11acd5e12a693316.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1dd0f4a1709a9b139fe87f2b311cc0d129900b3f.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
 <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
 <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
 <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
 <8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
 <e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
 <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
 <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
 <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
 <f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
 <0472f95473283ce75285e458b22b86ff791d7a42.1285355033.git.mfm@muteddisk.com>
 <75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
 <30c1ad7f4200136e00723fd76da1e58200e6e5b0.1285355033.git.mfm@muteddisk.com>
 <06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
 <a2fd5831df37b0a306ab4ca51d2e86ea7ee06425.1285355033.git.mfm@muteddisk.com>
 <58b418c2e7311bffb13606a6b94e33ddb7569346.1285355033.git.mfm@muteddisk.com>
 <1dd0f4a1709a9b139fe87f2b311cc0d129900b3f.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/video/intelfb/Makefile |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/video/intelfb/Makefile b/drivers/video/intelfb/Makefile
index 6c782d3..f7d631e 100644
--- a/drivers/video/intelfb/Makefile
+++ b/drivers/video/intelfb/Makefile
@@ -4,7 +4,4 @@ intelfb-y := intelfbdrv.o intelfbhw.o
 intelfb-$(CONFIG_FB_INTEL_I2C) += intelfb_i2c.o
 intelfb-objs := $(intelfb-y)
 
-ifdef CONFIG_FB_INTEL_DEBUG
-#EXTRA_CFLAGS += -DDEBUG -DVERBOSE -DREGDUMP
-EXTRA_CFLAGS += -DDEBUG -DREGDUMP
-endif
+ccflags-$(CONFIG_FB_INTEL_DEBUG) := -DDEBUG -DREGDUMP
-- 
1.7.2.1

