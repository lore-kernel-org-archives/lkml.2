Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2FFOXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:23:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:34040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2FFOXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152359283"
Date: Wed, 6 Jun 2012 07:23:23 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
Message-ID: <20120606142323.GG28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338979188.2749.92.camel@twins>
 <20120606141247.GD28225@tassilo.jf.intel.com>
 <1338992061.2749.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338992061.2749.111.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:14:21PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:12 -0700, Andi Kleen wrote:
> > On Wed, Jun 06, 2012 at 12:39:48PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > cycles:p uses an special cycles encoding by default. However that is not
> > > > architectural, so it can only be used when the CPU is known
> > > > (it already caused problems on Sandy Bridge). It may or may not work
> > > > on future CPUs.
> > > > 
> > > > So make it opt-in only. Right now I enabled it on Core2, Nehalem, Westmere
> > > > and not on Sandy-Bridge or Atom.
> > > 
> > > No. 
> > 
> > What do you mean? Are you claiming it's architectural?
> 
> I mean this patch is shite.
> 
> You don't disable it because it doesn't work some place, you fix it.

I disable it because it's non architectural, like the description
says.

This code is not behind model numbers. You cannot do random model specific 
hacks like this without a model number check. And you already got burned
for it. It may well break again in the future because there's no
guarantee for these things working.

Arch perfmon just means you can use the parts guaranteed in
arch perfmon and nothing more.

Now on what model numbers exactly it should be on can be debated.
I was very conservative, but the set could likely be larger. 

But it's very clear this cannot be done without a model check.
I don't understand how you can even argue against that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
