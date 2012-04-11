Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab2DKWIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:08:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab2DKWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:08:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: [Regression + patch] i915 / PM: System resume broken on 945GM
Date: Thu, 12 Apr 2012 00:12:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204120012.46826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Unfortunately, your commit

commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Mar 21 10:48:18 2012 +0000

    drm/i915: Mark untiled BLT commands as fenced on gen2/3

breaks system resume on my Toshiba Portege R500 (945GM) which hangs hard
during or right after returning to X.

The appended patch fixes the issue for me, FWIW.

Thanks,
Rafael

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/gpu/drm/i915/i915_gem_execbuffer.c
===================================================================
--- linux.orig/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ linux/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -498,7 +498,7 @@ pin_and_fence_object(struct drm_i915_gem
 				if (ret)
 					goto err_unpin;
 			}
-			obj->pending_fenced_gpu_access = true;
+			obj->pending_fenced_gpu_access = need_fence;
 		}
 	}
 
