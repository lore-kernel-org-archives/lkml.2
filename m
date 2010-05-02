Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0EBPJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 11:09:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:49619 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756853Ab0EBPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 11:09:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19W00BI+ulWi9xFeLLP9QtwDuOzARHVQoP8Xdm9To
	ro3564fOF+qFtx
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: restore display on resume
Date: Sun,  2 May 2010 15:17:32 +0000
Message-Id: <1272813454-3229-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
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
index 1b435b3..b4baed6 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1777,6 +1777,9 @@ int viafb_resume(struct pci_dev *pdev)
 		    viaparinfo->shared->saved_regs,
 		    0x100 * sizeof(u32));
 
+	viafb_set_par(viafbinfo);
+	if (viafb_dual_fb)
+		viafb_set_par(viafbinfo1);
 	fb_set_suspend(viafbinfo, 0);
 
 fail:
-- 
1.6.3.2

