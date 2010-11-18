Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0KRLQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:16:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0KRLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:16:44 -0500
Date: Thu, 18 Nov 2010 12:16:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@google.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
Message-ID: <20101118111630.GB12667@basil.fritz.box>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
 <1290077254-12165-4-git-send-email-andi@firstfloor.org>
 <1290078779.2109.1341.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290078779.2109.1341.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:12:59PM +0100, Peter Zijlstra wrote:
> >  					  u64 enable_mask)
> >  {
> >  	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
> > +	if (hwc->extra_reg)
> > +		wrmsrl(hwc->extra_reg, hwc->extra_config);
> >  }
> 
> Just wondering, shouldn't we program the extra msr _before_ we flip the
> enable bit?

Yes that makes sense.

> > + * Runs later because per cpu allocations don't work early on.
> > + */
> > +__initcall(init_intel_percore);
> 
> I've got a patch moving the whole pmu init to early_initcall(), which is
> after mm_init() so it would actually work.

So do you want to make  this patchkit depend on that patch?
Or just integrate it and then change later?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
