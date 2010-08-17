Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0HQOfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:35:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56677 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab0HQOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:34:55 -0400
Subject: [PATCH] Fixes field names that changed
From: Henrique Camargo <henrique@henriquecamargo.com>
Reply-To: henrique@henriquecamargo.com
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Henrique Camargo
Date: Tue, 17 Aug 2010 11:34:42 -0300
Message-ID: <1282055682.1883.5.camel@lemming>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_VIDEO_ADV_DEBUG was set, the driver failed to compile because the fields get_register and set_register changed names to s_register and s_register in the struct v4l2_subdev_core_ops.

Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>
---
 drivers/media/video/mt9t031.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 716fea6..f3d1995 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -499,8 +499,8 @@ static const struct v4l2_subdev_core_ops mt9t031_core_ops = {
 	.g_ctrl	= mt9t031_get_control,
 	.s_ctrl	= mt9t031_set_control,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.get_register = mt9t031_get_register,
-	.set_register = mt9t031_set_register,
+	.g_register = mt9t031_get_register,
+	.s_register = mt9t031_set_register,
 #endif
 };
 
-- 
1.7.0.4



