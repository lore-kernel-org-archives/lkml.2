Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab2CUJx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:53:29 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48796 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2CUJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 08/11] input/amijoy: Add missing platform check
Date: Wed, 21 Mar 2012 10:51:52 +0100
Message-Id: <1332323515-7314-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On multi-platform kernels, the Amiga joystick driver may be initialized
when running on Amiga only. Else it may crash later.
Fortunately this driver is almost always compiled as a module (to avoid
conflicts with the mouse driver), so it needs an explicit insmod to
trigger a crash.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/joystick/amijoy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 0bc8620..3aa93bf 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -108,6 +108,9 @@ static int __init amijoy_init(void)
 	int i, j;
 	int err;
 
+	if (!MACH_IS_AMIGA)
+		return -ENODEV;
+
 	for (i = 0; i < 2; i++) {
 		if (!amijoy[i])
 			continue;
-- 
1.7.0.4

