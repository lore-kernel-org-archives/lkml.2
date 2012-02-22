Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2BVSdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:33:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36860 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754789Ab2BVSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:33:37 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/sR30foTTsY0jB1Alex+V/0WlGAo3cfnsJDHHcZt
	zoLRo79clrJnzn
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH 4/5] viafb: fix IGA1 modesetting on VX900
Date: Wed, 22 Feb 2012 18:53:08 +0000
Message-Id: <43951de17c7a84280f3fbfb10d681ee73149a96e.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329936280.git.FlorianSchandinat@gmx.de>
References: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the documentation calls this bit "Reserved" it has to be set
to 0 for correct modesetting on IGA1.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: stable@vger.kernel.org
---
 drivers/video/via/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index e6e7a8f..376af05 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1804,6 +1804,9 @@ static void hw_init(void)
 		break;
 	}
 
+	/* magic required on VX900 for correct modesetting on IGA1 */
+	via_write_reg_mask(VIACR, 0x45, 0x00, 0x01);
+
 	/* probably this should go to the scaling code one day */
 	via_write_reg_mask(VIACR, 0xFD, 0, 0x80); /* VX900 hw scale on IGA2 */
 	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));
-- 
1.7.9

