Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1EJPXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:23:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1EJPXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:23:11 -0400
Date: Tue, 10 May 2011 08:13:05 -0700
From: Greg KH <gregkh@suse.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Borislav Petkov <bp@alien8.de>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
Message-ID: <20110510151305.GA9824@suse.de>
References: <20110420020128.GA27631@suse.de>
 <1303265862.3464.77.camel@localhost>
 <20110420031105.GA11945@suse.de>
 <1303274910.3464.95.camel@localhost>
 <20110420050617.GA16756@suse.de>
 <1303356555.3464.128.camel@localhost>
 <20110505225302.GC12316@suse.de>
 <20110506074120.GB21046@liondog.tnic>
 <1305032339.4065.276.camel@localhost>
 <20110510140219.GB16789@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510140219.GB16789@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 04:02:19PM +0200, Borislav Petkov wrote:
> On Tue, May 10, 2011 at 08:58:59AM -0400, Ben Hutchings wrote:
> > I read that:
> > 
> > "
> >     Support for Always Running APIC timer (ARAT) was introduced in
> >     commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
> >     allows us to avoid switching timers from LAPIC to something else
> >     (e.g. HPET) and go into timer broadcasts when entering deep
> >     C-states.
> >     
> >     AMD processors don't provide a CPUID bit for that feature but
> >     they also keep APIC timers running in deep C-states (except for
> >     cases when the processor is affected by erratum 400). Therefore
> >     we should set ARAT feature bit on AMD CPUs.
> > "
> > 
> > This implies that the HPET was previously used during deep C-states, and
> > that all this erratum checking is about deciding whether the CPU has
> > ARAT.  So what bug is being fixed by using ARAT instead of the HPET?
> 
> That's a good question, actually. The original upstream commit
> b87cf80af3ba4b4c008b4face3c68d604e1715c6 wasn't tagged for stable and
> Boris O. didn't send it to stable either, as I'm being told.
> 
> Maybe Greg has an idea?

I added it because it was needed to get another errata patch to apply
properly, and I saw no reason not to apply other "quirks" like this to
older kernels, right?

Or should I not have done that?

thanks,

greg k-h
