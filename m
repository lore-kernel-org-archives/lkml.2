Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab0HXXDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:40 -0400
Received: from kroah.org ([198.145.64.141]:32805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab0HXXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:29 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.404354116@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [094/114] drm/radeon/kms/DCE3+: switch pads to ddc mode when going i2c
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 5786e2c5a3f519647c50bbc276e45d36a704415a upstream.

The pins for ddc and aux are shared so you need to switch the
mode when doing ddc.  The ProcessAuxChannel table already sets
the pin mode to DP.  This should fix unreliable ddc issues
on DP ports using non-DP monitors.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_i2c.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -95,6 +95,13 @@ static void radeon_i2c_do_lock(struct ra
 		}
 	}
 
+	/* switch the pads to ddc mode */
+	if (ASIC_IS_DCE3(rdev) && rec->hw_capable) {
+		temp = RREG32(rec->mask_clk_reg);
+		temp &= ~(1 << 16);
+		WREG32(rec->mask_clk_reg, temp);
+	}
+
 	/* clear the output pin values */
 	temp = RREG32(rec->a_clk_reg) & ~rec->a_clk_mask;
 	WREG32(rec->a_clk_reg, temp);


