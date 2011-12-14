Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab1LNQ4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:56:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1LNQ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:56:53 -0500
Date: Wed, 14 Dec 2011 17:55:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Message-ID: <20111214165459.GB32305@elte.hu>
References: <cover.1323803130.git.tony.luck@intel.com>
 <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
 <20111214074749.GD25232@elte.hu>
 <20111214160702.GH23589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214160702.GH23589@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Wed, Dec 14, 2011 at 08:47:49AM +0100, Ingo Molnar wrote:
> > > -/* dummy to break dependency. actual code is in mm/memory-failure.c */
> > > -void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
> > > +#ifndef CONFIG_MEMORY_FAILURE
> > > +int memory_failure(unsigned long pfn, int vector, int flags)
> > >  {
> > >  	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
> > 
> > Btw., while at it, could we phrase this message in a more 
> > obvious way to users, such as 'Non-fatal memory failure at 
> > %lx ignored'?
> 
> Yeah, that's might not be as correct as we want it to be. AO 
> means it is an uncorrectable error, i.e. it will become fatal 
> if we'd consumed it, but it isn't that now because we just saw 
> it passing by in the cacheline...
> 
> Maybe "Fatal, unconsumed error ignored..."

There's also the distinction that tells us which context is 
affected by an error: the currently executing task/mm, or some 
other one.

So you can keep the terminology i guess lacking a better 
alternative, i just wanted to point out that it's likely 
confusing to users.

Thanks,

	Ingo
