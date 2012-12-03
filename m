Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2LCOt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:49:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399Ab2LCOgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:18 -0500
Message-Id: <20121203143157.036969202@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Bolle <pebolle@tiscali.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 68/89] radeon: add AGPMode 1 quirk for RV250
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 45171002b01b2e2ec4f991eca81ffd8430fd0aec upstream.

The Intel 82855PM host bridge / Mobility FireGL 9000 RV250 combination
in an (outdated) ThinkPad T41 needs AGPMode 1 for suspend/resume (under
KMS, that is). So add a quirk for it.

(Change R250 to RV250 in comment for preceding quirk too.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index 10ea17a..4243334 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -69,9 +69,12 @@ static struct radeon_agpmode_quirk radeon_agpmode_quirk_list[] = {
 	/* Intel 82830 830 Chipset Host Bridge / Mobility M6 LY Needs AGPMode 2 (fdo #17360)*/
 	{ PCI_VENDOR_ID_INTEL, 0x3575, PCI_VENDOR_ID_ATI, 0x4c59,
 		PCI_VENDOR_ID_DELL, 0x00e3, 2},
-	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 R250 Needs AGPMode 1 (lp #296617) */
+	/* Intel 82852/82855 host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 (lp #296617) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4c66,
 		PCI_VENDOR_ID_DELL, 0x0149, 1},
+	/* Intel 82855PM host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 for suspend/resume */
+	{ PCI_VENDOR_ID_INTEL, 0x3340, PCI_VENDOR_ID_ATI, 0x4c66,
+		PCI_VENDOR_ID_IBM, 0x0531, 1},
 	/* Intel 82852/82855 host bridge / Mobility 9600 M10 RV350 Needs AGPMode 1 (deb #467460) */
 	{ PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4e50,
 		0x1025, 0x0061, 1},


