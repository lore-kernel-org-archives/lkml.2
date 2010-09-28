Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0I1MBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:01:50 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38768 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0I1MBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:01:49 -0400
Date: Tue, 28 Sep 2010 05:00:00 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jan Beulich <JBeulich@novell.com>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
Message-ID: <20100928120000.GA7139@ericsson.com>
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
 <20100924185509.GA20155@ericsson.com>
 <4CA05F220200007800018F81@vpn.id2.novell.com>
 <20100927121650.GB31847@ericsson.com>
 <4CA0AE5E0200007800019097@vpn.id2.novell.com>
 <20100927130220.GA2277@ericsson.com>
 <20100928091759.421b5bf2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100928091759.421b5bf2@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 03:17:59AM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Mon, 27 Sep 2010 06:02:20 -0700, Guenter Roeck wrote:
> > On Mon, Sep 27, 2010 at 08:46:54AM -0400, Jan Beulich wrote:
> > > Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> > > > Seems to me the dependency should not exist in the first place, then.
> > > > Otherwise, the driver would still be disabled for GENERIC_CPU, which isn't
> > > > good either.
> > > 
> > > Oh, not having a dependency on PCI at all would be even better.
> > > I didn't dare to suggest that.
> > > 
> > > > Are there examples of other drivers which are not defining the PCI 
> > > > dependency
> > > > but are conditionally calling pci functions ?
> > > 
> > > I'm not aware of any, but also didn't explicitly look for such.
> >
> > It still compiles if I remove the PCI dependency and disable PCI. So that is one plus.
> > 
> > That whole dependency is just to get the host bridge ID which is then used
> > to determine tjmax. Personally I would prefer to have a wrong tjmax over not having 
> > coretemp at all,
> 
> No! Reporting broken monitoring values is worse than not returning any
> value at all. The coretemp (and k8/k10temp) driver(s) already have a
> very bad reputation for presenting relative temperature readings as
> absolute ones, please let's not add to it.
> 
Point taken.

> At this point there are 2 things which can be done:
> * If building a kernel for the Atom platform without PCI support is
>   something relatively common, which makes sense, then we should look
>   for an alternative way to determine the TjMax value for these CPUs,
>   which doesn't require PCI support.
> * If building a kernel for the Atom platform without PCI support is
>   something rare, which makes little sense, then we can simply either
>   prevent the driver from building at all in this case, or have it
>   print a big fat warning (with suggestion to rebuild the kernel with
>   PCI support) when it can't determine the TjMax value.
> 

I would prefer the first of those. Second might be an option too
if that is not possible.

> > and the means to determine tjmax through the bridge ID is kind
> > of bogus anyway.
> 
> Do you mean it is strange from a technical perspective, or do you have
> evidences that it doesn't work properly? This trick come from Intel
> themselves, I would guess they know their business.
> 
>From a technical perspective. Hard to see what a PCI bridge ID has to do with Tjmax.

> > So at least in this case it would make sense for me to remove
> > the dependency completely. Actually, we won't even change functionality,
> > since tjmax is only set to a higher value for specific bridge IDs.
> 
> Higher or lower doesn't make a difference. As long as the coretemp
> driver doesn't properly report the temperature values as being
> relative, users don't expect the value to change depending on the
> kernel version or configuration options. We have had dozens of user
> reports because of this.
> 
You are right, functionality would change if someone runs a kernel with PCI undefined 
on the specific systems which do use the PCI bridge ID to determine Tjmax. So 
if there are no other options, maybe the big fat warning in that case would make sense.
I would definitely prefer that over disabling coretemp entirely just because it _might_
possibly report a wrong Tjmax (which it doees anyway for many CPUs).

Guenter
