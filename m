Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0FOMWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:22:54 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:62785 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0FOMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:22:52 -0400
Date: Tue, 15 Jun 2010 14:21:50 +0200 (MEST)
From: Nils Carlson <nils.carlson@ludd.ltu.se>
X-X-Sender: pyssling@dexter.ludd.ltu.se
To: Andi Kleen <andi@firstfloor.org>
cc: Nils Carlson <nils.carlson@ludd.ltu.se>, Doug Thompson <norsk5@yahoo.com>,
       Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       BrentYoung <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Nils Carlson <nils.carlson@ericsson.com>
Subject: Re: Hardware Error Kernel Mini-Summit
In-Reply-To: <20100615114135.GH6727@basil.fritz.box>
Message-ID: <Pine.GSO.4.58.1006151411370.17929@dexter.ludd.ltu.se>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com>
 <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box>
 <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
 <20100615114135.GH6727@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, 15 Jun 2010, Andi Kleen wrote:

> On Tue, Jun 15, 2010 at 10:06:33AM +0200, Nils Carlson wrote:
>
> Hi Nils,
>
> > Could you maybe provide some references on how DIMM layout
> > could be read from DMI? I can't find anything nearly this specific,
> > or is it something we're expecting to happen in future BIOS's?
>
> The hardware (or BIOS) tells you the DIMM. You read the DIMMs
> from DMI and map them using the locators. The locator strings
> are not standardized, but there are not too many different
> formats around, so they can be implemented.
>
> Again this does not give you full layout, but it gives
> you a "path to a DIMM" and a DIMM locator.

Hmm.. From having a quick look at our boards I can conclude
that the information our BIOS puts in their is useless.
Will discuss durther with our BIOS writers. They do
their own error detection during the boot in which they
decode to DIMM's, so obviously the information is in there
(somewhere).

> An alternative is also to use the ACPI based reporting
> mechanism which is needed on some system. In this case
> the CPER gives you a reference to the DMI object of the DIMM.
>
> In principle DMI has more information (arrays, ranges etc.)
> but in my experience that is not strong enough to really find
> the DIMM on modern systems. You need hardware or BIOS help for this.

So what are we left with? Non-standardised locator strings
that may or may not be present at the mercy of the bios-writer?
I'm already feeling depressed. Re-writing EDAC to try to
make sense of this information seems overly risky.

I think in general that this is one of the wonderfull things
about linux, you're not so much at the mercy of BIOS-writers.
As soon as we start relying on the BIOS for functionality we're
encouraging the BIOS people to put more functionality in there,
and BIOS functionality is great, as long as there are no bugs!

But there are bugs. And correcting them is so prohibitively
expensive that I don't even want to think about it. And when
the BIOS messes up, it's the device driver writers who have to
magically workaround the problems.

Could we come up with some plan that doesn't involve
trusting to the goodwill (and competence) of BIOS writes?

I personally really like the device tree compiler for PowerPC.
It allows you to be explicit about what you have. Not for everyone,
but maybe there could be some way to apply the same principle? Maybe
some way of loading modules with parameters or configuring your setup
from sysfs?

/Nils
