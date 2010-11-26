Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0KZP22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:28:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39009 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0KZP21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:28:27 -0500
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1290080774.2109.1378.camel@laptop>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	 <1290077254-12165-4-git-send-email-andi@firstfloor.org>
	 <1290078779.2109.1341.camel@laptop>
	 <20101118111630.GB12667@basil.fritz.box>
	 <1290080774.2109.1378.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 16:28:33 +0100
Message-ID: <1290785313.2145.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 12:46 +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 12:16 +0100, Andi Kleen wrote:
> > 
> > > > + * Runs later because per cpu allocations don't work early on.
> > > > + */
> > > > +__initcall(init_intel_percore);
> > > 
> > > I've got a patch moving the whole pmu init to early_initcall(), which is
> > > after mm_init() so it would actually work.
> > 
> > So do you want to make  this patchkit depend on that patch?
> > Or just integrate it and then change later? 
> 
> Doesn't really matter, I can fix it up afterwards, just wanted to let
> you know.. I can also flip that enable thing.
> 
> I'll take these 4 patches and fixup these things and then see what falls
> out ;-)

OK, that initcall patch hit -tip and Ingo wants that allocation stuff
fixed up before committing those patches.

Could you run another version of these patches (you can ignore the
checkpatch output that results from the non-std struct initialization
layout)?

Just make the allocation path like the AMD NB stuff, use the cpu_prepare
and cpu_dead hooks to alloc/free and add a refcount in the percpu
object.


