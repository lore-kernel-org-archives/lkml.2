Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1EMK1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:27:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35806 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978Ab1EMK1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:27:23 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/2] gma500: Don't try and take a GEM handle of a non GEM fb
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 13 May 2011 11:08:26 +0100
Message-ID: <20110513100808.10267.77941.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial GMA500 framebuffer is not GEM but stolen memory. We can't
therefore take a GEM handle of it. Stop anyone trying to do this and causing
a crash.

Ideally we need a way to have GEM handles to non GEM objects but it's not
clear how and if GEM and the modesetting/fb interfaces it provides are
supposed to or indeed if they can handle it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 32d3ea3..5028459 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -667,6 +667,8 @@ static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 {
         struct psb_framebuffer *psbfb = to_psb_fb(fb);
         struct gtt_range *r = psbfb->gtt;
+        if (r->stolen)
+                return -EOPNOTSUPP;
         return drm_gem_handle_create(file_priv, &r->gem, handle);
 }
 

