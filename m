Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2C1I5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:57:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2C1I5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:57:36 -0400
Date: Wed, 28 Mar 2012 10:57:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
Message-ID: <20120328085732.GV22197@one.firstfloor.org>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com> <20120328064928.GA21725@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328064928.GA21725@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 08:49:28AM +0200, Ingo Molnar wrote:
> 
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
> > Hi, all
> > 
> > Here is the RFC patches to add uncore counting support for Nehalem,
> > Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> > The code is based on Lin Ming's old patches.
> > 
> > You can use 'perf stat' to access to the uncore pmu. For example:
> > perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1
> 
> My main complaint is that that's not user friendly *AT ALL*.
> 
> You need to make this useful to mere mortals: go through the 
> SDM, categorize interesting looking events, look at how it can 

The main problem is that we don't know currently what events are
really useful. People need to play around with the raw events
first to find that out. But to do that really already need some
in tree support because out of tree is too painful to use: it's 
a chicken and egg problem.

> be expressed via tooling, add a generic event where appropriate, 
> provide examples, actually *USE* it to improve the kernel or an 

Yes it needs to be used, exactly.

To do that need the base line driver be available first, so that
this experience can be gained.

The only way to satisfy your request now would be to put in
some unproven events as generic events, probably not a good idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
