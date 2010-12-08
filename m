Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab0LHB06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:26:58 -0500
Received: from kroah.org ([198.145.64.141]:33466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab0LHBC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.387041606@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [179/289] drm/radeon/kms: fix i2c pad masks on rs4xx
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit be66305718bee9927e6acc6b75618ce3cd745718 upstream.

These got lost in the last i2c cleanup.  Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=23222

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -571,6 +571,7 @@ static struct radeon_i2c_bus_rec combios
 	}
 
 	if (clk_mask && data_mask) {
+		/* system specific masks */
 		i2c.mask_clk_mask = clk_mask;
 		i2c.mask_data_mask = data_mask;
 		i2c.a_clk_mask = clk_mask;
@@ -579,7 +580,19 @@ static struct radeon_i2c_bus_rec combios
 		i2c.en_data_mask = data_mask;
 		i2c.y_clk_mask = clk_mask;
 		i2c.y_data_mask = data_mask;
+	} else if ((ddc_line == RADEON_GPIOPAD_MASK) ||
+		   (ddc_line == RADEON_MDGPIO_MASK)) {
+		/* default gpiopad masks */
+		i2c.mask_clk_mask = (0x20 << 8);
+		i2c.mask_data_mask = 0x80;
+		i2c.a_clk_mask = (0x20 << 8);
+		i2c.a_data_mask = 0x80;
+		i2c.en_clk_mask = (0x20 << 8);
+		i2c.en_data_mask = 0x80;
+		i2c.y_clk_mask = (0x20 << 8);
+		i2c.y_data_mask = 0x80;
 	} else {
+		/* default masks for ddc pads */
 		i2c.mask_clk_mask = RADEON_GPIO_EN_1;
 		i2c.mask_data_mask = RADEON_GPIO_EN_0;
 		i2c.a_clk_mask = RADEON_GPIO_A_1;


