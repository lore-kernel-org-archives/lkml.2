Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab1LOQ2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:28:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52845 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759064Ab1LOQ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:28:39 -0500
Date: Thu, 15 Dec 2011 16:28:24 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: IRQ migration on CPU offline path
Message-ID: <20111215162824.GM15131@mudshark.cambridge.arm.com>
References: <20111214183446.GB12703@mudshark.cambridge.arm.com>
 <m1bora8w3k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bora8w3k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Cheers for the response.

On Thu, Dec 15, 2011 at 01:25:19AM +0000, Eric W. Biederman wrote:
> Will Deacon <will.deacon@arm.com> writes:
> > I've been looking at the IRQ migration code on x86 (fixup_irqs) for the CPU
> > hotplug path in order to try and fix a bug we have on ARM with the
> > desc->affinity mask not getting updated. Compared to irq_set_affinity, the code
> > is pretty whacky (I guess because it's called via stop_machine) so I wondered if
> > you could help me understand a few points:
> 
> There is a lot of craziness on that path because of poor hardware design
> on x86 we can't know when an irq has actually be migrated, and other
> nasties.
> 
> There is also the issue that I expect is still the case that we have the
> generic layer asking us to cpu migration and the associated irq
> migrations with the irqs disabled which at least for the bits of poorly
> designed hardware made the entire path a best effort beast.

Argh, ok. Does this mean that other architectures should just preserve the
interface that x86 gives (for example not triggering IRQ affinity
notifiers)?

> If x86 becomes a good clean example in this corner case I would be
> amazed.  Last I looked I almost marked it all as CONFIG_BROKEN because
> we were trying to do the impossible.  Unfortunately peoples laptops
> go through this path when they suspend and so it was more painful to
> disable hacky racy mess than to keep living with it.
> 
> There has been an increase in the number of cases where it is possible
> to actually perform the migration with irqs disabled so on a good day
> that code might even work.  

Right, so this stuff is fairly fragile. We can probably get a reasonable
version working on ARM (with the GIC present) but I'm not sure what to do
about the notifiers I mentioned earlier and proper migration of threaded
interrupt handlers.

I'll take a look at some other archs.

Thanks,

Will
