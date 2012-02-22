Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2BVSdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:33:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35613 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754498Ab2BVSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:33:21 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+FUiln2hiF3lBosDKRw0Hrsg7GuK5BfTvsr2kfg1
	0cPJCLqsE2W6+V
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH 3/5] viafb: select HW scaling on VX900 for IGA2
Date: Wed, 22 Feb 2012 18:53:07 +0000
Message-Id: <a2ef94234a7d5794359f8246c44d1e3503eda89d.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329936280.git.FlorianSchandinat@gmx.de>
References: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VX900 can do hardware scaling for both IGAs in contrast to previous
hardware which could do it only for IGA2. This patch ensures that
we set the parameter for IGA2 and not for IGA1. This fixes hardware
scaling on VX900 until we have the infrastructure to support it for
both IGAs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: stable@vger.kernel.org
---
 drivers/video/via/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 4d799c8..e6e7a8f 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1805,6 +1805,7 @@ static void hw_init(void)
 	}
 
 	/* probably this should go to the scaling code one day */
+	via_write_reg_mask(VIACR, 0xFD, 0, 0x80); /* VX900 hw scale on IGA2 */
 	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));
 
 	/* Fill VPIT Parameters */
-- 
1.7.9

