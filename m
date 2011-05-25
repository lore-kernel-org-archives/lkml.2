Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1EYLkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:40:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58055 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab1EYLkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:40:22 -0400
Date: Wed, 25 May 2011 13:40:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: linux-next: manual merge of the dwmw2-iommu tree with Linus' tree
Message-ID: <20110525114010.GF30983@elte.hu>
References: <20110525130004.150c054f.sfr@canb.auug.org.au>
 <20110525091636.GC28500@elte.hu>
 <alpine.LFD.2.02.1105251133001.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105251133001.3164@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 25 May 2011, Ingo Molnar wrote:
> 
> > That particular change was still under discussion and i'm not at all 
> > sure we want to do it like that. So please repost the latest version.
> 
> I had not seen such discussion; I had the impression that having dealt 
> with my feedback about making the thing more visible to the user, Youquan
> considered the patch complete.

I lurked your discussion with Youquan and expected another iteration 
posted. I was keeping my gun powder dry for the next round because i 
saw you reaping the patch to pieces already and there was nothing 
more to say really :)

> I am more than happy to absolve responsibility for this patch 
> altogether and drop it from tree, though. It is *absolutely* the 
> wrong approach, in my opinion. If the BIOS is broken and cannot 
> cope with x2apic, the solution is to line the "engineers" 
> responsible up against the wall and shoot them. And then to 
> implement a "quiesce all SMI" feature that the OS can invoke, and 
> make it mandatory. Presumably that's the underlying problem they 
> were trying to solve?
> 
> The answer certainly isn't to add a flag in the DMAR table to opt 
> out of x2apic use, when afaict the kernel is capable of using 
> x2apic in some cases even when the *is* no DMAR. (Either that, or 
> we have a lot of dead code in that area which *looks* like it copes 
> with x2apic+!dmar).

Yeah, that was exactly my main concern as well: why should we allow 
the BIOS to tell us not to use a CPU feature that the CPU tells us is 
usable?

We generally do not allow such level of BIOS control. They should fix 
the BIOS to not generate DMAR tables at all if they want us to 'opt 
out', or ship a CPU without x2apic (or a CPU microcode version that 
turns off the x2apic CPUID bit or whatever).

So unless i missed some fine detail of control here, the whole idea 
of generating DMAR tables (which were always inherently connected to 
x2apic really) that tell us 'never mind about x2apic!' seems rather 
counter-productive ...

> I'll drop this patch from my tree when I get home and happily wash 
> my hands of it. It's all yours; have fun :)

Thanks. Youquan, mind resending the latest and greatest version so we 
can continue flami^W iterating it? Please also Cc: David.

Thanks,

	Ingo
