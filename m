Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab0DHRSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:18:54 -0400
Received: from tex.lwn.net ([70.33.254.29]:46518 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0DHRQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:59 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 12/16] fix register save count, so it matches the restore count.
Date: Thu,  8 Apr 2010 11:15:42 -0600
Message-Id: <1270746946-12467-13-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

Signed-off-by: Paul Fox <pgf@laptop.org>
---
 drivers/video/via/viafbdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 88298e1..5a5964f 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1852,7 +1852,7 @@ static int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
 
 		memcpy_fromio(viaparinfo->shared->saved_regs,
 			      viaparinfo->shared->engine_mmio + 0x100,
-			      0xff * sizeof(u32));
+			      0x100 * sizeof(u32));
 
 		fb_set_suspend(viafbinfo, 1);
 
-- 
1.7.0.1

