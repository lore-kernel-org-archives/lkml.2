Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2JFIn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:43:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:34107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab2JFInP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:43:15 -0400
Message-Id: <b94cdc$6rvo8m@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="230678806"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 3.5 regression on i915
To: Willy Tarreau <w@1wt.eu>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>
In-Reply-To: <20121006082016.GA22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <b94cdc$6rvjl8@fmsmga001.fm.intel.com> <20121006082016.GA22618@1wt.eu>
Date: Sat, 06 Oct 2012 09:43:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 10:20:16 +0200, Willy Tarreau <w@1wt.eu> wrote:
> Hi Chris,
> 
> On Sat, Oct 06, 2012 at 09:04:34AM +0100, Chris Wilson wrote:
> > > The crash happens here in i915_gem_entervt_ioctl() :
> > > 
> > >     3659          BUG_ON(!list_empty(&dev_priv->mm.active_list));
> > >     3660          BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
> > >  -> 3661          BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
> > >     3662          mutex_unlock(&dev->struct_mutex);
> > 
> > That BUG_ON there is silly and can simply be removed. The check is to
> > verify that no batches were submitted to the kernel whilst the UMS/GEM
> > client was suspended - to which the BUG_ONs are a crude approximation.
> > Furthermore, the checks are too late, since it means we attempted to
> > program the hardware whilst it was in an invalid state, the BUG_ONs are
> > the least of your concerns at that point.
> 
> Excellent, that fixed it ! X still segfaults when KMS is used, but
> I expect more of a pure user-space issue here since there is nothing
> in dmesg.
> 
> Would some of you accept the following patch and tag it for -stable ?

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
