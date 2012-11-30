Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768864Ab2K3TNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:13:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:59495 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992949Ab2K3TCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Bolle <pebolle@tiscali.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 27/54] radeon: add AGPMode 1 quirk for RV250
Date: Fri, 30 Nov 2012 10:55:58 -0800
Message-Id: <20121130185210.625621660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 45171002b01b2e2ec4f991eca81ffd8430fd0aec upstream.

The Intel 82855PM host bridge / Mobility FireGL 9000 RV250 combination
in an (outdated) ThinkPad T41 needs AGPMode 1 for suspend/resume (under
KMS, that is). So add a quirk for it.

(Change R250 to RV250 in comment for preceding quirk too.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -70,9 +70,12 @@ static struct radeon_agpmode_quirk radeo
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


