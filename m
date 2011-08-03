Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1HCXlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:41:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1HCX10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:48 2011
Message-Id: <20110803221248.703713623@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [047/102] drm/radeon/kms: fix i2c map for rv250/280
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6dd666333ddee39903d86f870d5c40d9f100e0cc upstream.

Those chips have crt2_ddc bus.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=39672

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -779,7 +779,8 @@ void radeon_combios_i2c_init(struct rade
 				}
 			}
 		}
-	} else if (rdev->family >= CHIP_R200) {
+	} else if ((rdev->family == CHIP_R200) ||
+		   (rdev->family >= CHIP_R300)) {
 		/* 0x68 */
 		i2c = combios_setup_i2c_bus(rdev, DDC_MONID, 0, 0);
 		rdev->i2c_bus[3] = radeon_i2c_create(dev, &i2c, "MONID");


