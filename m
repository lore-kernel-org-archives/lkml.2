Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0IXEuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:50:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751154Ab0IXEuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:50:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18rmJ0yHRor/KP39A45JU4QSKiFh/tfRXcioT3Y8a
	YhNJtWm/xX9QtY
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/4] viafb: restore display on resume
Date: Fri, 24 Sep 2010 05:01:24 +0000
Message-Id: <e16aa3895c06ec782df51f030dda61bc2ba322cc.1285303223.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes viafb restore the display on resume by calling
viafb_set_par. Resumeing has still its issues:
- will probably freeze most machines (for me on VX800 reliable on the
  second resume)
- under some configurations the screen appears on the wrong output
  device (reason unknown)

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/viafbdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index f2b68cc..5b23293 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1522,6 +1522,9 @@ int viafb_resume(struct pci_dev *pdev)
 		    viaparinfo->shared->saved_regs,
 		    0x100 * sizeof(u32));
 
+	viafb_set_par(viafbinfo);
+	if (viafb_dual_fb)
+		viafb_set_par(viafbinfo1);
 	fb_set_suspend(viafbinfo, 0);
 
 fail:
-- 
1.6.3.2

