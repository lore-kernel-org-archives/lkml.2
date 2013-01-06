Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3AFRZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:25:55 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45861 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab3AFRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:25:50 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH V4 3/3] adv7180: remove {query/g_/s_}ctrl
Date: Sun,  6 Jan 2013 18:29:03 +0100
Message-Id: <1357493343-13090-3-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All drivers which use this subdevice use also the control framework.
The v4l2_subdev_core_ops operations {query/g_/s_}ctrl are useless because
device drivers will inherit controls from this subdevice.

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/i2c/adv7180.c | 3 ---
 1 file modificato, 3 rimozioni(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 45ecf8d..43bc2b9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -402,9 +402,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.g_chip_ident = adv7180_g_chip_ident,
 	.s_std = adv7180_s_std,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
 };
 
 static const struct v4l2_subdev_ops adv7180_ops = {
-- 
1.7.11.7

