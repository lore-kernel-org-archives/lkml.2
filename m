Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2KTVaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:30:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2KTVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:30:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH v2 1/3] input: increase struct ps2dev cmdbuf[] to 8 bytes
Date: Tue, 20 Nov 2012 13:30:08 -0800
Message-Id: <1353447010-4852-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353447010-4852-1-git-send-email-kamal@canonical.com>
References: <1353447010-4852-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress PS/2 Trackpad (drivers/input/mouse/cypress_ps2.c) needs
this larger cmdbuf[] to handle 8-byte packet responses.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/libps2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/libps2.h b/include/linux/libps2.h
index 79603a6..4ad06e8 100644
--- a/include/linux/libps2.h
+++ b/include/linux/libps2.h
@@ -36,7 +36,7 @@ struct ps2dev {
 	wait_queue_head_t wait;
 
 	unsigned long flags;
-	unsigned char cmdbuf[6];
+	unsigned char cmdbuf[8];
 	unsigned char cmdcnt;
 	unsigned char nak;
 };
-- 
1.7.10.4

