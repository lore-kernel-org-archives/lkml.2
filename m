Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2C1JbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:31:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44745 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2C1JbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:31:03 -0400
Date: Wed, 28 Mar 2012 11:30:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, eranian@google.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
Message-ID: <20120328093058.GE22885@gmail.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
 <20120328064928.GA21725@gmail.com>
 <20120328085732.GV22197@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328085732.GV22197@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Mar 28, 2012 at 08:49:28AM +0200, Ingo Molnar wrote:
> > 
> > * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > 
> > > Hi, all
> > > 
> > > Here is the RFC patches to add uncore counting support for Nehalem,
> > > Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> > > The code is based on Lin Ming's old patches.
> > > 
> > > You can use 'perf stat' to access to the uncore pmu. For example:
> > > perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1
> > 
> > My main complaint is that that's not user friendly *AT ALL*.
> > 
> > You need to make this useful to mere mortals: go through the 
> > SDM, categorize interesting looking events, look at how it can 
> 
> The main problem is that we don't know currently what events 
> are really useful. People need to play around with the raw 
> events first to find that out. But to do that really already 
> need some in tree support because out of tree is too painful 
> to use: it's a chicken and egg problem.

Nonsense. User-space hacks can be used for experimenting around, 
raw access to /dev/msr has in fact be used to implement uncore 
support in the past ... It has not helped the least to bring 
useful tooling forward, I'd in fact argue the opposite: access 
to raw events helped *hide* real usecases.

So guys, please give me some tangible reason to merge it and 
some real way for developers to use it. The kernel is already 
complex enough as-is, "it might be useful in the future" or
"I don't want to tell my sekrit usecases" does not fly.

If you can't be bothered to make it useful to everyone then 
frankly we can't be bothered to maintain it upstream, it's 
really that simple.

Thanks,

	Ingo
