Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1ATLAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:00:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:31695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab1ATLA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:00:29 -0500
Message-Id: <0d30dc$kqbkiv@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,350,1291622400"; 
   d="scan'208";a="698733151"
Date: Thu, 20 Jan 2011 11:00:25 +0000
To: Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] drm/i915: Dont kick-off hangcheck after a DRI interrupt
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
References: <20110120070508.GA2345@gondor.apana.org.au> <1295517361-15825-1-git-send-email-chris@chris-wilson.co.uk> <20110120101010.GA4299@gondor.apana.org.au>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110120101010.GA4299@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 21:10:10 +1100, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> While the current kernel tree has indeed changed from 2.6.36,
> I don't think this is the spot corresponding to my crash.
> 
> My spot was in hangcheck_elapsed and as far as I can see it will
> crash in the current kernel in pretty much the same way.  In
> particular, i915_hangcheck_ring_idle will probably crash on all
> three rings.

Except that i915_hangcheck_elapsed should not be called from DRI code
paths, the whole error recovery code only works with GEM (we can't recover
the hardware if it is being poked directly by "userspace").
 
> FWIW after adding the INIT_LIST_HEAD to the init_dri function
> my kernel hasn't crashed yet (a couple of hours and counting).

Ah, yes. Need to pull some more code in from init_ringbuffer.

For my sanity can you check that the above patch also prevents the crash?
I'd rather not install a timer, and execute undesirable code paths, if we
don't need one.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
