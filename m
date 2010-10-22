Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab0JVTWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:22:12 -0400
Received: from kroah.org ([198.145.64.141]:33977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab0JVS4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.029317765@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [019/103] drm/radeon/kms: fix bad cast/shift in evergreen.c
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit d31dba58480c3cdd458f449261d72ecd15287792 upstream.

Missing parens.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=30718

Reported-by: Dave Gilbert <freedesktop@treblig.org>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1120,7 +1120,7 @@ static void evergreen_gpu_init(struct ra
 
 		WREG32(RCU_IND_INDEX, 0x203);
 		efuse_straps_3 = RREG32(RCU_IND_DATA);
-		efuse_box_bit_127_124 = (u8)(efuse_straps_3 & 0xF0000000) >> 28;
+		efuse_box_bit_127_124 = (u8)((efuse_straps_3 & 0xF0000000) >> 28);
 
 		switch(efuse_box_bit_127_124) {
 		case 0x0:


