Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0H3FYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:24:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38531 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0H3FYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:24:05 -0400
Date: Mon, 30 Aug 2010 07:23:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Xiang Hai hao <haihao.xiang@intel.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.36-rc3
Message-ID: <20100830052358.GA3506@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jean-Denis Girard <jd.girard@sysnux.pf>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Eric Anholt <eric@anholt.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Xiang Hai hao <haihao.xiang@intel.com>,
	dri-devel@lists.freedesktop.org
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
 <loom.20100830T003135-767@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <loom.20100830T003135-767@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Denis Girard <jd.girard@sysnux.pf>
Date: Sun, Aug 29, 2010 at 10:40:47PM +0000

>   CC      drivers/gpu/drm/i915/intel_overlay.o
> drivers/gpu/drm/i915/intel_overlay.c: In function 
> ‘intel_overlay_print_error_state’:
> drivers/gpu/drm/i915/intel_overlay.c:1467: erreur: implicit declaration 
> of function ‘seq_printf’
> make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Erreur 1
> make[3]: *** [drivers/gpu/drm/i915] Erreur 2
> make[2]: *** [drivers/gpu/drm] Erreur 2
> make[1]: *** [drivers/gpu] Erreur 2
> make: *** [drivers] Erreur 2
> Command exited with non-zero status 2

This should fix it:

---
From: Borislav Petkov <bp@alien8.de>

Add a missing include fixing driver build.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/gpu/drm/i915/intel_overlay.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index 4f00390..4eaf08e 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -25,6 +25,8 @@
  *
  * Derived from Xorg ddx, xf86-video-intel, src/i830_video.c
  */
+#include <linux/seq_file.h>
+
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
-- 
1.7.1

-- 
Regards/Gruss,
    Boris.
