Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506Ab2I1TDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476Ab2I1TDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 186/262] drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to cover later silicon stepping
Date: Fri, 28 Sep 2012 11:51:55 -0700
Message-Id: <20120928183020.019588872@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


