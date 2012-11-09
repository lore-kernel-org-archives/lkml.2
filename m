Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2KIMLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:11:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2KIMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:11:15 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm: use memchr_inv()
Date: Fri,  9 Nov 2012 21:10:42 +0900
Message-Id: <1352463043-9408-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com>
References: <1352463043-9408-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv() to check the specified memory region is filled with zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_edid.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index fadcd44..59260bf 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -307,12 +307,9 @@ drm_do_probe_ddc_edid(struct i2c_adapter *adapter, unsigned char *buf,
 
 static bool drm_edid_is_zero(u8 *in_edid, int length)
 {
-	int i;
-	u32 *raw_edid = (u32 *)in_edid;
+	if (memchr_inv(in_edid, 0, length))
+		return false;
 
-	for (i = 0; i < length / 4; i++)
-		if (*(raw_edid + i) != 0)
-			return false;
 	return true;
 }
 
-- 
1.7.11.7

