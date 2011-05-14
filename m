Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1ENHzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 03:55:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:4059 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1ENHzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 03:55:19 -0400
Message-Id: <013811$1gi55@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,367,1301900400"; 
   d="scan'208";a="1591461"
Date: Sat, 14 May 2011 08:55:15 +0100
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: Wavering Arrandale output
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20110513204511.GA2187@joana>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110513204511.GA2187@joana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 17:45:11 -0300, "Gustavo F. Padovan" <padovan@profusion.mobi> wrote:
> Hi Chris,
> 
> Bug #28306 is going to complete his first birthday at the end of this month,
> it is nagging around for a long time and I have many interest in fix this.
> 
> So I tested your patch in duplicated bug #36599 and it doesn't work, but I
> managed to add some printks(see diff) there to help debug.
> 
> [    1.033866] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
> [    1.033868] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
> [    1.033869] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 1
> [    1.034120] [drm:intel_crtc_mode_set] *ERROR* is_lvds 1
> [    1.034121] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
> (null)
> [    1.191465] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
> [    1.191466] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
> [    1.191468] [drm:intel_crtc_mode_set] *ERROR* encoder->type 1
> [    1.191469] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 0
> [    1.191720] [drm:intel_crtc_mode_set] *ERROR* is_lvds 0
> [    1.191721] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
> (null)
> 
> It seems your patch has no effect once has_edp_encoder is null. Can you please
> look into this? I can provide any test you may want, just send me the patches.
> ;)

With no eDP on the system, we wouldn't expect to apply any of the eDP
settings.

Even after your fix to the patch, nothing? Can you try just setting
use_ssc=0 (and keep your fix).

In 633f2ea26665d37bb3c8ae30799aa14988622653 (drm/i915: Disable SSC for
outputs other than LVDS or DP) I tried to implement another aspect of
source-clock control, that is the patch that appeared to work if you only
had VGA connected. So the next step would be to combine the two patches.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
