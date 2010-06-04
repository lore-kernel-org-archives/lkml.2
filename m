Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0FDIAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:00:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36341 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0FDIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=pdgMNUNDweVvpXed9V0WFHc62yeVoUoglOHA3KRLb+qT87MQ+CacpoqBJxL1rqnq3o
         D+zCADuZQ1RFKrhESyK+EAJ8OIzc5qsYU8ZYcYRvwSq5DfgFEkfxElPNV/AMZmmS44SP
         CL37ieVq/ApeqohOGeBAEHTcmIFZOk/xfMnVg=
Date: Fri, 4 Jun 2010 16:00:16 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Carl Worth <cworth@cworth.org>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Commit cfecde435dda78248d6fcdc424bed68d5db6be0b turns screen blank
Message-ID: <Pine.LNX.4.64.1006041552280.2417@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The following commit causes screen to become blank. Upon boot up, screen 
becomes blank (monitor can't sync to pc) with i915 compiled in the 
kernel. With i915 as module, system boots up fine, but becomes blank as 
soon as the module is loaded.

Reverting it solves the problem. Problem only happens only Dell Optiplex 
780 with external LCD. But, works fine on Lenovo X201s internal LCD.


Thanks,
Jeff

commit cfecde435dda78248d6fcdc424bed68d5db6be0b
Author: Carl Worth <cworth@cworth.org>
Date:   Thu Apr 8 23:31:57 2010 -0700

     drm/i915: Don't enable pipe/plane/VCO early (wait for DPMS on).

     The existing code handling the DPMS ON event is much more careful to
     ensure that these registers are enabled according to strict sequencing
     requirements. Enabling these early in mode_set simply defeats that.

     Signed-off-by: Carl Worth <cworth@cworth.org>
     Signed-off-by: Eric Anholt <eric@anholt.net>

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3ee68bc..243dfb8 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3463,11 +3463,6 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
  			pipeconf &= ~PIPEACONF_DOUBLE_WIDE;
  	}

-	dspcntr |= DISPLAY_PLANE_ENABLE;
-	pipeconf |= PIPEACONF_ENABLE;
-	dpll |= DPLL_VCO_ENABLE;
-
-
  	/* Disable the panel fitter if it was on our pipe */
  	if (!HAS_PCH_SPLIT(dev) && intel_panel_fitter_pipe(dev) == pipe)
  		I915_WRITE(PFIT_CONTROL, 0);
