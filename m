Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1I3SXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:23:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:60426 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab1I3SXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:23:50 -0400
Message-Id: <c55c5d$l6fkn@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,468,1312182000"; 
   d="scan'208";a="22232727"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH 05/21] drm/i915: Check eDP power when doing aux channel communications
To: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <yun1uux9afx.fsf@aiko.keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-6-git-send-email-keithp@keithp.com> <20110930170242.GE2859@phenom.ffwll.local> <yun1uux9afx.fsf@aiko.keithp.com>
Date: Fri, 30 Sep 2011 19:23:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 11:01:06 -0700, Keith Packard <keithp@keithp.com> wrote:
Non-text part: multipart/signed
> On Fri, 30 Sep 2011 19:02:42 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Use pp_control instead of re-reading?
> 
> Could, but you'll note a later patch eliminates both pp_status and
> pp_control local variables, so I didn't bother to clean this up when
> refactoring.
> 
> > dp_aux_ch does the low-level io for the below, so either this one or the
> > below three hunks look a bit redundant.
> 
> Yeah, probably not necessary. I just added checks everywhere I could
> think of to try and figure out where power was not being applied when
> needed.
> 
> Should I bother to include this patch in the series at all? It's purely
> for diagnostics to make sure the panel is powered during all aux channel
> transactions.

Yes, adding the extra checks made my day. :)

Modesetting bugs are the hardest to reproduce so every additional check
(with a reasonable false positive rate) is worth their weight in gold when
it comes to diagnosing misbehaving hardware. And the checks improve the
maintainability of the code.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
