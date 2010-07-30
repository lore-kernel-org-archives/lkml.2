Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab0G3Sal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:30:41 -0400
Received: from kroah.org ([198.145.64.141]:58183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759897Ab0G3RzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.305331892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Scheidegger <sroland@vmware.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [063/205] drm/radeon/kms: CS checker texture fixes for r1xx/r2xx/r3xx
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Scheidegger <sroland@vmware.com>

commit f9da52d54eb0e8822b5e7f32ab1cfa6522533d6e upstream.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=28459

agd5f: apply to r1xx/r2xx as well.

Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c |    3 +++
 drivers/gpu/drm/radeon/r200.c |    3 +++
 drivers/gpu/drm/radeon/r300.c |    5 +++++
 3 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1392,6 +1392,7 @@ static int r100_packet0_check(struct rad
 		case RADEON_TXFORMAT_RGB332:
 		case RADEON_TXFORMAT_Y8:
 			track->textures[i].cpp = 1;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case RADEON_TXFORMAT_AI88:
 		case RADEON_TXFORMAT_ARGB1555:
@@ -1403,12 +1404,14 @@ static int r100_packet0_check(struct rad
 		case RADEON_TXFORMAT_LDUDV655:
 		case RADEON_TXFORMAT_DUDV88:
 			track->textures[i].cpp = 2;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case RADEON_TXFORMAT_ARGB8888:
 		case RADEON_TXFORMAT_RGBA8888:
 		case RADEON_TXFORMAT_SHADOW32:
 		case RADEON_TXFORMAT_LDUDUV8888:
 			track->textures[i].cpp = 4;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case RADEON_TXFORMAT_DXT1:
 			track->textures[i].cpp = 1;
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -452,6 +452,7 @@ int r200_packet0_check(struct radeon_cs_
 		case R200_TXFORMAT_RGB332:
 		case R200_TXFORMAT_Y8:
 			track->textures[i].cpp = 1;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R200_TXFORMAT_AI88:
 		case R200_TXFORMAT_ARGB1555:
@@ -463,6 +464,7 @@ int r200_packet0_check(struct radeon_cs_
 		case R200_TXFORMAT_DVDU88:
 		case R200_TXFORMAT_AVYU4444:
 			track->textures[i].cpp = 2;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R200_TXFORMAT_ARGB8888:
 		case R200_TXFORMAT_RGBA8888:
@@ -470,6 +472,7 @@ int r200_packet0_check(struct radeon_cs_
 		case R200_TXFORMAT_BGR111110:
 		case R200_TXFORMAT_LDVDU8888:
 			track->textures[i].cpp = 4;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R200_TXFORMAT_DXT1:
 			track->textures[i].cpp = 1;
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -881,6 +881,7 @@ static int r300_packet0_check(struct rad
 		case R300_TX_FORMAT_Y4X4:
 		case R300_TX_FORMAT_Z3Y3X2:
 			track->textures[i].cpp = 1;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R300_TX_FORMAT_X16:
 		case R300_TX_FORMAT_Y8X8:
@@ -892,6 +893,7 @@ static int r300_packet0_check(struct rad
 		case R300_TX_FORMAT_B8G8_B8G8:
 		case R300_TX_FORMAT_G8R8_G8B8:
 			track->textures[i].cpp = 2;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R300_TX_FORMAT_Y16X16:
 		case R300_TX_FORMAT_Z11Y11X10:
@@ -902,14 +904,17 @@ static int r300_packet0_check(struct rad
 		case R300_TX_FORMAT_FL_I32:
 		case 0x1e:
 			track->textures[i].cpp = 4;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R300_TX_FORMAT_W16Z16Y16X16:
 		case R300_TX_FORMAT_FL_R16G16B16A16:
 		case R300_TX_FORMAT_FL_I32A32:
 			track->textures[i].cpp = 8;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R300_TX_FORMAT_FL_R32G32B32A32:
 			track->textures[i].cpp = 16;
+			track->textures[i].compress_format = R100_TRACK_COMP_NONE;
 			break;
 		case R300_TX_FORMAT_DXT1:
 			track->textures[i].cpp = 1;


