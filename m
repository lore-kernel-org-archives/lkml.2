Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0FOLlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:41:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab0FOLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:41:37 -0400
Date: Tue, 15 Jun 2010 13:41:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
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
Message-ID: <20100615114135.GH6727@basil.fritz.box>
References: <AANLkTil_mDFOsDUjvnp_NFZvkj0Ij-qww6BqewJ4lpHP@mail.gmail.com> <35525.41387.qm@web50105.mail.re2.yahoo.com> <20100615065630.GC6727@basil.fritz.box> <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.1006150951150.17579@dexter.ludd.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:06:33AM +0200, Nils Carlson wrote:

Hi Nils,

> Could you maybe provide some references on how DIMM layout
> could be read from DMI? I can't find anything nearly this specific,
> or is it something we're expecting to happen in future BIOS's?

The hardware (or BIOS) tells you the DIMM. You read the DIMMs
from DMI and map them using the locators. The locator strings
are not standardized, but there are not too many different
formats around, so they can be implemented.

Again this does not give you full layout, but it gives
you a "path to a DIMM" and a DIMM locator. 

An alternative is also to use the ACPI based reporting
mechanism which is needed on some system. In this case
the CPER gives you a reference to the DMI object of the DIMM. 

In principle DMI has more information (arrays, ranges etc.)
but in my experience that is not strong enough to really find
the DIMM on modern systems. You need hardware or BIOS help for this.

This is implemented in mcelog today.

> 
> Also, there would probably need to be some standard describing
> different DIMM layouts in general, though maybe such a thing exists.

I don't think the goal is to have full DIMM layout. This will
never replace your schemantics.

The goal is to find which DIMM has a problem. So have a path
and a locator. The path may tell you some additional information
(e.g. channel), but that's hard to generalize.

> 
> In other words, there would be have to be some way of ascertaining
> that the info you read from DMI is sufficient to decode MCEs so that
> a faulting DIMM can be identified. In an ideal world, this could
> be tested by some simple tool that could be run by the BIOS writers
> to test that they're providing the OS with sufficient info.

That's difficult in a general way, you will probably always 
need some system specific test plan.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
