Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2IXK4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:56:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65158 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2IXK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:56:43 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v3 4/4] adv7180: remove {query/g_/s_}ctrl
Date: Mon, 24 Sep 2012 12:58:52 +0200
Message-Id: <1348484332-8106-4-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
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
1.7.11.4

