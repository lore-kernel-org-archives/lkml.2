Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1BVWVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:18 -0500
Received: from kroah.org ([198.145.64.141]:46590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1BVWVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.180007477@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Ben Skeggs <bskeggs@redhat.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [11/70] drm/nouveau: Only select ACPI_VIDEO if its dependencies are met
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c42988012ad9c1807b7c7a5ff855cd630094989b upstream.

CONFIG_ACPI_VIDEO depends on more than just CONFIG_ACPI, so add those
dependencies to the Kconfig select condition.  The case where some
dependencies fail to be satisfied should be handled correctly, because
in that case the ACPI_VIDEO symbols we use are converted into
static-inline stubs.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,7 +10,7 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
-	select ACPI_VIDEO if ACPI
+	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	help
 	  Choose this option for open-source nVidia support.
 


