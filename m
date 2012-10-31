Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260Ab2J3SOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:14:55 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59048 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934100Ab2J3SMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:46 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 14:12:41 EDT
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] da8xx: De-constify members in the platform config.
Date: Wed, 31 Oct 2012 17:56:29 +0200
Message-Id: <1351698989-4049-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for this to be const. It interferes with
creating the platform data dynamically.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 include/video/da8xx-fb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/video/da8xx-fb.h b/include/video/da8xx-fb.h
index 5a0e4f9..a512d6b 100644
--- a/include/video/da8xx-fb.h
+++ b/include/video/da8xx-fb.h
@@ -35,9 +35,9 @@ struct display_panel {
 };
 
 struct da8xx_lcdc_platform_data {
-	const char manu_name[10];
+	char manu_name[10];
 	void *controller_data;
-	const char type[25];
+	char type[25];
 	void (*panel_power_ctrl)(int);
 };
 
-- 
1.7.12

