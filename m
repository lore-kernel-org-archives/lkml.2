Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694Ab2FGER2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650Ab2FGERX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:23 -0400
Message-Id: <20120607040340.505364472@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mehdi Aqadjani Memar <m.aqadjanimemar@student.ru.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 28/82] drm/radeon: fix XFX quirk
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1ebf169ad4dc68f18cc0dab35163b0f324fc6c41 upstream.

Only override the ddc bus if the connector doesn't have
a valid one.  The existing code overrode the ddc bus for
all connectors even if it had ddc bus.

Fixes ddc on another XFX card with the same pci ids that
was broken by the quirk overwriting the correct ddc bus.

Reported-by: Mehdi Aqadjani Memar <m.aqadjanimemar@student.ru.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -444,7 +444,9 @@ static bool radeon_atom_apply_quirks(str
 	 */
 	if ((dev->pdev->device == 0x9498) &&
 	    (dev->pdev->subsystem_vendor == 0x1682) &&
-	    (dev->pdev->subsystem_device == 0x2452)) {
+	    (dev->pdev->subsystem_device == 0x2452) &&
+	    (i2c_bus->valid == false) &&
+	    !(supported_device & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT))) {
 		struct radeon_device *rdev = dev->dev_private;
 		*i2c_bus = radeon_lookup_i2c_gpio(rdev, 0x93);
 	}


