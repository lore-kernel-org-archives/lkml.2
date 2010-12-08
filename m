Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0LHBCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:32 -0500
Received: from kroah.org ([198.145.64.141]:33452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab0LHBCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:24 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.078562275@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [176/289] drm/radeon/kms: add workaround for dce3 ddc line vbios bug
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 3074adc8b6d9bf28b574a58241b958057a69a7a0 upstream.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=23752

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -98,6 +98,14 @@ static inline struct radeon_i2c_bus_rec
 				}
 			}
 
+			/* some DCE3 boards have bad data for this entry */
+			if (ASIC_IS_DCE3(rdev)) {
+				if ((i == 4) &&
+				    (gpio->usClkMaskRegisterIndex == 0x1fda) &&
+				    (gpio->sucI2cId.ucAccess == 0x94))
+					gpio->sucI2cId.ucAccess = 0x14;
+			}
+
 			if (gpio->sucI2cId.ucAccess == id) {
 				i2c.mask_clk_reg = le16_to_cpu(gpio->usClkMaskRegisterIndex) * 4;
 				i2c.mask_data_reg = le16_to_cpu(gpio->usDataMaskRegisterIndex) * 4;
@@ -174,6 +182,14 @@ void radeon_atombios_i2c_init(struct rad
 				}
 			}
 
+			/* some DCE3 boards have bad data for this entry */
+			if (ASIC_IS_DCE3(rdev)) {
+				if ((i == 4) &&
+				    (gpio->usClkMaskRegisterIndex == 0x1fda) &&
+				    (gpio->sucI2cId.ucAccess == 0x94))
+					gpio->sucI2cId.ucAccess = 0x14;
+			}
+
 			i2c.mask_clk_reg = le16_to_cpu(gpio->usClkMaskRegisterIndex) * 4;
 			i2c.mask_data_reg = le16_to_cpu(gpio->usDataMaskRegisterIndex) * 4;
 			i2c.en_clk_reg = le16_to_cpu(gpio->usClkEnRegisterIndex) * 4;


