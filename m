Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0LHB0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:26:21 -0500
Received: from kroah.org ([198.145.64.141]:33474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0LHBCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.577690949@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [181/289] drm/radeon/kms: fix regression in rs4xx i2c setup
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 791cfe2684a74ed7155254816ff9e89e6064277c upstream.

typo in my last i2c rework.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=23222

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -729,7 +729,7 @@ void radeon_combios_i2c_init(struct rade
 					clk = RBIOS8(offset + 3 + (i * 5) + 3);
 					data = RBIOS8(offset + 3 + (i * 5) + 4);
 					i2c = combios_setup_i2c_bus(rdev, DDC_MONID,
-								    clk, data);
+								    (1 << clk), (1 << data));
 					rdev->i2c_bus[4] = radeon_i2c_create(dev, &i2c, "GPIOPAD_MASK");
 					break;
 				}


