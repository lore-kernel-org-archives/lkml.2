Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1BXAN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:13:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:60569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1BXAN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:13:58 -0500
Message-Id: <0d30dc$l7ehaa@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,214,1297065600"; 
   d="scan'208";a="712459594"
Date: Thu, 24 Feb 2011 00:13:53 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm fixes
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Indan Zupancic <indan@nul.nu>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie> <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 15:58:02 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Feb 23, 2011 at 3:17 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > Nothing too major,
> >
> > Two regression fixers (one revert that got fixes properly elsewhere), some
> > timestamp fixes and an agp module reload fix.
> 
> Pulled. However, what about the report from	Pavel Machek <pavel@ucw.cz>:
> 
> > >      drm/i915: Completely disable fence pipelining.
> >
> > Reverting this commit helps in v2.6.38-rc5+ when screen is not fully updated,
> > or has a corrupted picture like horizontal black or white stripes. Using a
> > compositor like compiz may help to avoid the problem.
> >
> > See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572
> 
> Any update on that one?

No, reverting that will cause just another bug elsewhere. I need to
work out how the gpu is not being flushed with a non-pipelined fence
change.

> There's that whole "return -EINVAL for
> I915_PARAM_HAS_RELAXED_FENCING" patch thing?

As it turns out this is a bug in the userspace components of the stack for
gen2 hardware, with lax kernel side enforcement. Daniel has a fix for both.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
