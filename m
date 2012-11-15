Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2KOEX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:23:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:49728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993213Ab2KOEMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Egbert Eich <eich@suse.de>, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 16/57] DRM/Radeon: Fix Load Detection on legacy primary DAC.
Date: Wed, 14 Nov 2012 20:11:24 -0800
Message-Id: <20121115040934.219731568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 83325d072185899b706de2956170b246585aaec9 upstream.

An uninitialized variable led to broken load detection.

Signed-off-by: Egbert Eich <eich@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -650,6 +650,7 @@ static enum drm_connector_status radeon_
 	tmp |= RADEON_DAC_RANGE_CNTL_PS2 | RADEON_DAC_CMP_EN;
 	WREG32(RADEON_DAC_CNTL, tmp);
 
+	tmp = dac_macro_cntl;
 	tmp &= ~(RADEON_DAC_PDWN_R |
 		 RADEON_DAC_PDWN_G |
 		 RADEON_DAC_PDWN_B);


