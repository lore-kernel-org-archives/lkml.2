Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1KSAJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758319Ab1KSAJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.586801969@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [07/26] drm/radeon/kms: make an aux failure debug only
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 091264f0bc12419560ac64fcef4567809d611658 upstream.

Can happen when there is no DP panel attached, confusing
users.  Make it debug only.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -283,7 +283,7 @@ int radeon_dp_i2c_aux_ch(struct i2c_adap
 		}
 	}
 
-	DRM_ERROR("aux i2c too many retries, giving up\n");
+	DRM_DEBUG_KMS("aux i2c too many retries, giving up\n");
 	return -EREMOTEIO;
 }
 


