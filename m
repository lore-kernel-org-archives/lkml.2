Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0DHRSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:18:40 -0400
Received: from tex.lwn.net ([70.33.254.29]:46541 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011Ab0DHRRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:17:01 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 14/16] Remove cursor restore hack in viafb
Date: Thu,  8 Apr 2010 11:15:44 -0600
Message-Id: <1270746946-12467-15-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Saxena <dsaxena@laptop.org>

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
---
 drivers/video/via/viafbdev.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 56d5416..684a5c4 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1940,15 +1940,6 @@ static int viafb_resume(struct pci_dev *pdev)
 	viaVidEng->cursor_bg = localVidEng->cursor_bg;
 	viaVidEng->cursor_fg = localVidEng->cursor_fg;
 
-	/*
-	 * Magic register dance to  make cursor reappear.
-	 *
-	 * Currently hardcoded settings need to clean this all
-	 * up later...
-	 */
-	viaVidEng->hi_control = 0xb6000005;
-	viaVidEng->compose   |= 0xc0000000;
-
 	fb_set_suspend(viafbinfo, 0);
 
 fail:
-- 
1.7.0.1

