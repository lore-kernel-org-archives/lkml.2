Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1I1WjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1I1WjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.321742591@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [048/244] drm/radeon/kms: evergreen & ni reset SPI block on CP resume
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit a49a50dad48586d42ebac1a6730c3a3cd5603421 upstream.

For some reason SPI block is in broken state after module
unloading. This lead to broken rendering after reloading
module. Fix this by reseting SPI block in CP resume function

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    1 +
 drivers/gpu/drm/radeon/ni.c        |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1357,6 +1357,7 @@ int evergreen_cp_resume(struct radeon_de
 				 SOFT_RESET_PA |
 				 SOFT_RESET_SH |
 				 SOFT_RESET_VGT |
+				 SOFT_RESET_SPI |
 				 SOFT_RESET_SX));
 	RREG32(GRBM_SOFT_RESET);
 	mdelay(15);
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1158,6 +1158,7 @@ int cayman_cp_resume(struct radeon_devic
 				 SOFT_RESET_PA |
 				 SOFT_RESET_SH |
 				 SOFT_RESET_VGT |
+				 SOFT_RESET_SPI |
 				 SOFT_RESET_SX));
 	RREG32(GRBM_SOFT_RESET);
 	mdelay(15);


