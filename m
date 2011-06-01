Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163163Ab1FAI2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163151Ab1FAI23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:29 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:22 2011
Message-Id: <20110601081221.944678353@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:01 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [151/165] drm/radeon/kms: fix tile_config value reported to userspace
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 on cayman.
Content-Length: 987
Lines: 27

From: Dave Airlie <airlied@redhat.com>

commit cde5083b051e9c66c99a8764aefbc13349e7730d upstream.

cayman is reporting the wrong tile config value to userspace, this
causes piglit mipmap generation tests to fail.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/ni.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -829,7 +829,7 @@ static void cayman_gpu_init(struct radeo
 	rdev->config.cayman.tile_config |=
 		((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) << 4;
 	rdev->config.cayman.tile_config |=
-		(gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT;
+		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;
 	rdev->config.cayman.tile_config |=
 		((gb_addr_config & ROW_SIZE_MASK) >> ROW_SIZE_SHIFT) << 12;
 


