Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1HCX1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab1HCX1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:48 2011
Message-Id: <20110803221248.906958376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [049/102] drm/radeon/kms: add missing vddci setting on NI+
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4639dd21e759e32125adc7171abf6cb8140d54cf upstream.

Need to add vddci setting to pm init as well as
resume.  Fixes hangs on load on some boards.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=38754

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -594,6 +594,9 @@ int radeon_pm_init(struct radeon_device
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
 							SET_VOLTAGE_TYPE_ASIC_VDDC);
+			if (rdev->pm.default_vddci)
+				radeon_atom_set_voltage(rdev, rdev->pm.default_vddci,
+							SET_VOLTAGE_TYPE_ASIC_VDDCI);
 			if (rdev->pm.default_sclk)
 				radeon_set_engine_clock(rdev, rdev->pm.default_sclk);
 			if (rdev->pm.default_mclk)


