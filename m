Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1KZK5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:57:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:23907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab1KZK5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:57:33 -0500
Message-Id: <e0d58a$2cdsbh@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80146801"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
To: Rakib Mullick <rakib.mullick@gmail.com>, Keith Packard <keithp@keithp.com>
Cc: akpm@linux-foundation.org, dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com>
References: <1321382968.8791.4.camel@localhost.localdomain> <20111121162306.GB3807@phenom.ffwll.local> <868vn9ieey.fsf@sumi.keithp.com> <CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com>
Date: Sat, 26 Nov 2011 10:57:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011 10:44:17 +0600, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Mon, Nov 21, 2011 at 11:16 PM, Keith Packard <keithp@keithp.com> wrote:
> > On Mon, 21 Nov 2011 17:23:06 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> >> Indeed, nice catch (albeit totally unlikely to be hit, because the error
> >> only happens when the gpu ceases to progress in the ring, so imo not
> >> stable material). Keith, please pick this up for fixes, thanks.
> >
> > It's already there and queued for airlied :-)
> >
> Thank you guys for reviewing and taking the patch.
> 
> Now, while I was looking at the uses of i915_add_request(), I found
> the following code :
> 
>                         ret = i915_gem_flush_ring(ring, 0,
> I915_GEM_GPU_DOMAINS);
>                         request = kzalloc(sizeof(*request), GFP_KERNEL);
>                         if (ret || request == NULL ||
>                             i915_add_request(ring, NULL, request))
>                             kfree(request);
> 
> From above code, we might ended up by calling kfree(request) without
> allocating request. Though, it's unlikely cause if request is NULL
> then BUG_ON will be hit in i915_add_request(). So, to unify the callee
> uses of i915_add_request(), I'm proposing the following patch. Please
> let me know what do you guys think. If you guys agree, I can sent a
> formal patch.

kfree(NULL) is permitted and taken advantage of here along with the
short-circuiting behaviour of '||'.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
