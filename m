Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab2JXIVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:21:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:22223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab2JXIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:21:38 -0400
Message-Id: <b94cdc$72fm1r@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="237492283"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: drm i915 hangs on heavy io load
To: Norbert Preining <preining@logic.at>, Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20121024003659.GA30962@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at>
Date: Wed, 24 Oct 2012 09:11:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 09:36:59 +0900, Norbert Preining <preining@logic.at> wrote:
> Hi Dave, hi Chris,
> 
> thanks for your answers.
> 
> On Di, 23 Okt 2012, Dave Airlie wrote:
> > Does booting with i915.i915_enable_rc6=0 help?
> 
> No,booted with that, it happened again on a completely idle
> system (well, I believe completely idle, I was doing the
> dishes ;-)
> 
> [12437.995026] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> [12437.995034] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> [12438.000213] [drm:init_ring_common] *ERROR* failed to set render ring head to zero ctl 00000000 head 5ee06f14 tail 00000000 start 00003000
> [12438.054894] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 5ee06f14 tail 00000000 start 00003000
> [12439.583064] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> [12439.583176] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> [12439.583182] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> New output see here:
> http://www.logic.at/people/preining/i915_error_state.gz

That has a very similar look to it, so reasonable to assume that is the
same issue.
 
> > http://cgit.freedesktop.org/~danvet/drm/commit/?h=ilk-wa-pile&id=0d5fed2de763b49bb1a90140758153481f043757
> > is the missing ingredient.
> 
> I am compiling a kernel with this patch based on current git now.
> Should I still use the above kernel cmd argument (i915...rc6=0)
> or try without it?

Without any rc6 parameter would be best. But if rc6=0 wasn't the
solution for you, then I may have identified the wrong w/a. Can I ask
you try the patches in that branch until you find one (or more perhaps)
that stabilise your system?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
