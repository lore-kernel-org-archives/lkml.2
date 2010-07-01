Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0GASXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:42 -0400
Received: from kroah.org ([198.145.64.141]:40572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922Ab0GASXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:39 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:13 2010
Message-Id: <20100701173213.557030064@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 080/149] drm/radeon: fix the r100/r200 ums block 0 page fix
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit cf22f20ade30f8c03955324aaf27b1049e182600 upstream.

airlied -> brown paper bag.

I blame Hi-5 or the Wiggles for lowering my IQ, move the fix inside some
brackets instead of breaking everything in site.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_state.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -878,9 +878,10 @@ static void radeon_cp_dispatch_clear(str
 			flags |= RADEON_FRONT;
 	}
 	if (flags & (RADEON_DEPTH|RADEON_STENCIL)) {
-		if (!dev_priv->have_z_offset)
+		if (!dev_priv->have_z_offset) {
 			printk_once(KERN_ERR "radeon: illegal depth clear request. Buggy mesa detected - please update.\n");
-		flags &= ~(RADEON_DEPTH | RADEON_STENCIL);
+			flags &= ~(RADEON_DEPTH | RADEON_STENCIL);
+		}
 	}
 
 	if (flags & (RADEON_FRONT | RADEON_BACK)) {


