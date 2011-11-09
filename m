Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005Ab1KJEdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:33:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935905Ab1KJDh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:37:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:44 2011
Message-Id: <20111109213144.722183190@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <jdelvare@suse.de>,
        Jerome Glisse <j.glisse@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [026/264] drm/radeon/kms: Fix I2C mask definitions
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 286e0c94f9c3f292cb38a977fbbde3433347a868 upstream.

Commit 9b9fe724 accidentally used RADEON_GPIO_EN_* where
RADEON_GPIO_MASK_* was intended. This caused improper initialization
of I2C buses, mostly visible when setting i2c_algo_bit.bit_test=1.
Using the right constants fixes the problem.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jerome Glisse <j.glisse@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -620,8 +620,8 @@ static struct radeon_i2c_bus_rec combios
 		i2c.y_data_mask = 0x80;
 	} else {
 		/* default masks for ddc pads */
-		i2c.mask_clk_mask = RADEON_GPIO_EN_1;
-		i2c.mask_data_mask = RADEON_GPIO_EN_0;
+		i2c.mask_clk_mask = RADEON_GPIO_MASK_1;
+		i2c.mask_data_mask = RADEON_GPIO_MASK_0;
 		i2c.a_clk_mask = RADEON_GPIO_A_1;
 		i2c.a_data_mask = RADEON_GPIO_A_0;
 		i2c.en_clk_mask = RADEON_GPIO_EN_1;


