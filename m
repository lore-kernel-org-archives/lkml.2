Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032975Ab2I1VXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:23:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032770Ab2I1UaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 150/218] drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to cover later silicon stepping
Date: Fri, 28 Sep 2012 13:16:07 -0700
Message-Id: <20120928201518.717904626@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>

commit 52e9b39d9a89ae33662596bd30e62dd56bddbe73 upstream.

There is a more recent APU stepping with a new PCI ID
shipping in the same board by Fujitsu which needs the
same quirk to correctly mark the back plane connectors.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -452,7 +452,7 @@ static bool radeon_atom_apply_quirks(str
 	}
 
 	/* Fujitsu D3003-S2 board lists DVI-I as DVI-D and VGA */
-	if ((dev->pdev->device == 0x9802) &&
+	if (((dev->pdev->device == 0x9802) || (dev->pdev->device == 0x9806)) &&
 	    (dev->pdev->subsystem_vendor == 0x1734) &&
 	    (dev->pdev->subsystem_device == 0x11bd)) {
 		if (*connector_type == DRM_MODE_CONNECTOR_VGA) {


