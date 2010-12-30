Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0L3Sgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:36:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:10314 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0L3Sgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:36:50 -0500
Message-Id: <849307$av3koe@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,251,1291622400"; 
   d="scan'208";a="368169742"
Date: Thu, 30 Dec 2010 18:36:45 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
In-Reply-To: <AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com> <20101229102127.06c0e505.randy.dunlap@oracle.com> <AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 11:40:04 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Dec 29, 2010 at 10:21 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > The only significant difference that I can see in the kernel message log
> > is this:
> 
> Hmm. I suspect that difference should have gone away with commit
> 92971021c6328 (Revert "drm: Don't try and disable an encoder that was
> never enabled"), but clearly that didn't fix your blank screen.
> 
> Does reverting commit 448f53a1ede54eb854d036abf54573281412d650
> ("drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks") fix it for
> you? It does for some people..
> 
> Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
> we please just disable spread-spectrum entirely? Or perhaps only if we
> notice that it was enabled already? Or something?

It appeared to be the easiest fix for the machines I had to hand and was
confirmed by several people with identical machines. However, it
definitely caused a regression for working panels and therefore it will
be reverted. 
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
