Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0DZSBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:01:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:36947 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754313Ab0DZSBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:01:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+SCXoZHS2SUXFVfxzvOGVd61GX9xS6apFS+/EDFp
	/FMdgObRz3TPCB
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: restore display on resume
Date: Mon, 26 Apr 2010 18:09:45 +0000
Message-Id: <1272305387-4872-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1272305387-4872-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1272305387-4872-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: restore display on resume

This patch makes viafb restore the display on resume by calling
viafb_set_par. Resumeing has still its issues:
- will probably freeze most machines (for me on VX800 reliable on the
  second resume)
- under some configurations the screen appears on the wrong output
  device (reason unknown)

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 8197096..4af5a43 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1769,6 +1769,9 @@ static int viafb_resume(struct pci_dev *pdev)
 		    viaparinfo->shared->saved_regs,
 		    0x100 * sizeof(u32));
 
+	viafb_set_par(viafbinfo);
+	if (viafb_dual_fb)
+		viafb_set_par(viafbinfo1);
 	fb_set_suspend(viafbinfo, 0);
 
 fail:
-- 
1.6.3.2

