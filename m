Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab2JKAYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:24:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36699 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933020Ab2JKAXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:23:54 -0400
X-Sasl-enc: LYjZh6LUsW0p15+URzTqfGHrHovrW/BCGptHA5of/k3v 1349915032
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: =?UTF-8?q?=5B=20079/122=5D=20drm/radeon/kms=3A=20allow=20STRMOUT=5FBASE=5FUPDATE=20on=20RS780=20and=20RS880?=
Date: Thu, 11 Oct 2012 07:54:05 +0900
Message-Id: <20121010225352.319948120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <maraeo@gmail.com>

commit 46fc8781bf428ce1094a5980ca2b92a49d33a8ca upstream.

This is required to make streamout work there.

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_cs.c    |    3 ++-
 drivers/gpu/drm/radeon/radeon_drv.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2180,7 +2180,8 @@ static int r600_packet3_check(struct rad
 		}
 		break;
 	case PACKET3_STRMOUT_BASE_UPDATE:
-		if (p->family < CHIP_RV770) {
+		/* RS780 and RS880 also need this */
+		if (p->family < CHIP_RS780) {
 			DRM_ERROR("STRMOUT_BASE_UPDATE only supported on 7xx\n");
 			return -EINVAL;
 		}
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -64,9 +64,10 @@
  *   2.20.0 - r600-si: RADEON_INFO_TIMESTAMP query
  *   2.21.0 - r600-r700: FMASK and CMASK
  *   2.22.0 - r600 only: RESOLVE_BOX allowed
+ *   2.23.0 - allow STRMOUT_BASE_UPDATE on RS780 and RS880
  */
 #define KMS_DRIVER_MAJOR	2
-#define KMS_DRIVER_MINOR	22
+#define KMS_DRIVER_MINOR	23
 #define KMS_DRIVER_PATCHLEVEL	0
 int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags);
 int radeon_driver_unload_kms(struct drm_device *dev);


