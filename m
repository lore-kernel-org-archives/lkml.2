Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1ASJJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:09:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36155 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1ASJJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:09:18 -0500
Date: Wed, 19 Jan 2011 10:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
Message-ID: <20110119090904.GA4927@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119073905.GA1652@gentoo.trippels.de>
 <20110119074902.GA1670@gentoo.trippels.de>
 <1295424766.1949.879.camel@sli10-conroe>
 <4D36A759.60704@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D36A759.60704@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <h.peter.anvin@intel.com> wrote:

> On 01/19/2011 12:12 AM, Shaohua Li wrote:
> > On Wed, 2011-01-19 at 15:49 +0800, Markus Trippelsdorf wrote:
> >> On 2011.01.19 at 08:39 +0100, Markus Trippelsdorf wrote:
> >>> On 2011.01.18 at 15:54 -0800, Linus Torvalds wrote:
> >>>>
> >>>> And as usual, report any regressions to the lists and the appropriate
> >>>> authorities.
> >>>
> >>> Unfortunately 2.6.38-rc1 doesn't even boot on my machine (amd64).
> >>> This is caused by 86b1e8dd83cbb0f:
> >>>     x86: Make relocatable kernel work with new binutils
> >>>
> >>> Reverting the commit solves the problem.
> >>
> >> I'm running the latest binutils:
> >> GNU ld (Linux/GNU Binutils) 2.21.51.0.5.20110104
> > Hmm, reproduce it here with binutils-2.21.51.0.6-20110118
> > but not with GNU ld (GNU Binutils for Ubuntu) 2.20.51-system.20100908
> > I got this in system.map: ffffffff03514880 D jiffies_64, which looks
> > wrong.
> > looks binutils changed something again.
> > Have no idea, CC Lu Hongjiu.
> > 
> 
> Either way... the whole jiffies vs jiffies_64 thing is kind of
> ridiculous.  We should be able to do it in a completely
> architecture-generic way by either making it a union(!) (with "jiffies"
> and "jiffies_64" presumably would be #defines, or we do a global replace
> across the tree), moving the variable declaration itself to a .S file
> (which would only have data components and therefore would be
> arch-generic) or doing something like the attached (untested since it is
> 1 am here) patch.
> 
> This should let us get rid of the hacks in *all* the architectures, not
> just x86.

Ok - until it's resolved i'll queue up a revert - a known build failure is preferred 
to a boot regression.

Thanks,

	Ingo
