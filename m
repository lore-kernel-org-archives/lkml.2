Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab1I1WjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1I1WjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.225750728@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [047/244] drm/radeon/kms: add s/r quirk for Compaq Presario V5245EU
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 302a8e8b06d312dcb3b718dfeb42aa912b5f426b upstream.

Fixes resume on Compaq Presario V5245EU.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=41642

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -3279,6 +3279,14 @@ void radeon_combios_asic_init(struct drm
 	    rdev->pdev->subsystem_device == 0x30a4)
 		return;
 
+	/* quirk for rs4xx Compaq Presario V5245EU laptop to make it resume
+	 * - it hangs on resume inside the dynclk 1 table.
+	 */
+	if (rdev->family == CHIP_RS480 &&
+	    rdev->pdev->subsystem_vendor == 0x103c &&
+	    rdev->pdev->subsystem_device == 0x30ae)
+		return;
+
 	/* DYN CLK 1 */
 	table = combios_get_table_offset(dev, COMBIOS_DYN_CLK_1_TABLE);
 	if (table)


