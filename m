Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2CIUOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:14:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031176Ab2CITuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:06 -0500
Message-Id: <20120309190208.909574980@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 82/95] drm/radeon/kms: set SX_MISC in the r6xx blit code (v2)
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <maraeo@gmail.com>

commit cf00790dea6f210ddd01a6656da58c7c9a4ea0e4 upstream.

Mesa may set it to 1, causing all primitives to be killed.

v2: also update the r7xx code

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_blit_shaders.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/r600_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/r600_blit_shaders.c
@@ -314,6 +314,10 @@ const u32 r6xx_default_state[] =
 	0x00000000, /* VGT_VTX_CNT_EN */
 
 	0xc0016900,
+	0x000000d4,
+	0x00000000, /* SX_MISC */
+
+	0xc0016900,
 	0x000002c8,
 	0x00000000, /* VGT_STRMOUT_BUFFER_EN */
 
@@ -626,6 +630,10 @@ const u32 r7xx_default_state[] =
 	0x00000000, /* VGT_VTX_CNT_EN */
 
 	0xc0016900,
+	0x000000d4,
+	0x00000000, /* SX_MISC */
+
+	0xc0016900,
 	0x000002c8,
 	0x00000000, /* VGT_STRMOUT_BUFFER_EN */
 


