Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1KKL6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:58:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61631 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838Ab1KKL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:58:17 -0500
Date: Fri, 11 Nov 2011 11:58:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 13/16] ARM: LPAE: Add identity mapping support for the
 3-level page table format
Message-ID: <20111111115802.GF12410@mudshark.cambridge.arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-14-git-send-email-catalin.marinas@arm.com>
 <20111110225517.GW12913@n2100.arm.linux.org.uk>
 <20111111113601.GE23243@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111113601.GE23243@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 11:36:01AM +0000, Catalin Marinas wrote:
> On Thu, Nov 10, 2011 at 10:55:17PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Nov 07, 2011 at 04:16:55PM +0000, Catalin Marinas wrote:
> > > +		pmd += pmd_index(addr);
> > > +	} else
> > > +		pmd = pmd_offset(pud, addr);
> > > +
> > > +	do {
> > > +		next = pmd_addr_end(addr, end);
> > > +		*pmd = __pmd((addr & PMD_MASK) | prot);
> > > +		flush_pmd_entry(pmd);
> > > +	} while (pmd++, addr = next, addr != end);
> > > +}
> > > +#else	/* !CONFIG_ARM_LPAE */
> > 
> > I'm not convinced about the wiseness of this.  One of the places where
> > this code is called is from the reboot paths, which can happen in atomic
> > context.  Trying to allocate memory in such a context is going to lead
> > to problems, especially if support for panic'ing on OOM, and rebooting
> > on panic'ing are both enabled.
> 
> A solution would be to have pre-set page table for identity mappings
> (which may even come in handy for power management) and avoid the
> allocation in idmap.c.

Yup, that's what I do in my latest kexec series (v5) so this problem goes
away then.

> > Therefore, I think this patch depends on the work Will has been doing to
> > re-structure the kexec and restart support.
> 
> I think Will can rebase his patches on top of mine (I touched this file
> first :)).

Haha, but my code doesn't depend on yours in order to work correctly!

Will
