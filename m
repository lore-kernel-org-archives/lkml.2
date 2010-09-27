Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab0I0NDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:03:39 -0400
Received: from imr4.ericy.com ([198.24.6.8]:37136 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616Ab0I0NDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:03:38 -0400
Date: Mon, 27 Sep 2010 06:02:20 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
Message-ID: <20100927130220.GA2277@ericsson.com>
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
 <20100924185509.GA20155@ericsson.com>
 <4CA05F220200007800018F81@vpn.id2.novell.com>
 <20100927121650.GB31847@ericsson.com>
 <4CA0AE5E0200007800019097@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CA0AE5E0200007800019097@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:46:54AM -0400, Jan Beulich wrote:
> >>> On 27.09.10 at 14:16, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> > On Mon, Sep 27, 2010 at 03:08:50AM -0400, Jan Beulich wrote:
> > [...]
> > 
> >> >>  
> >> >>  config SENSORS_CORETEMP
> >> >>  	tristate "Intel Core/Core2/Atom temperature sensor"
> >> >> -	depends on X86 && PCI && EXPERIMENTAL
> >> >> +	depends on X86 && EXPERIMENTAL
> >> >> +	depends on PCI || (!MATOM && !GENERIC_CPU && !X86_GENERIC)
> >> >>  	help
> >> >>  	  If you say yes here you get support for the temperature
> >> >>  	  sensor inside your CPU. Most of the family 6 CPUs
> >> > 
> >> > Resending my reply to this one as well. Again, apologies if there is 
> >> > duplication.
> >> > 
> >> > The coretemp code unconditionally calls pci functions, even if PCI is not 
> >> > defined.
> >> > I am concerned that this might cause problems. It might be better to stick 
> >> > with
> >> > the more generic dependency instead of trying to optimize too much.
> >> 
> >> pci.h takes care to define stub inline functions for the !CONFIG_PCI
> >> case. It seemed largely odd for a driver like this to depend on PCI
> >> at all, and hence I think it is more transparent to make the needs
> >> explicit.
> >> 
> > Seems to me the dependency should not exist in the first place, then.
> > Otherwise, the driver would still be disabled for GENERIC_CPU, which isn't
> > good either.
> 
> Oh, not having a dependency on PCI at all would be even better.
> I didn't dare to suggest that.
> 
> > Are there examples of other drivers which are not defining the PCI 
> > dependency
> > but are conditionally calling pci functions ?
> 
> I'm not aware of any, but also didn't explicitly look for such.
> 
It still compiles if I remove the PCI dependency and disable PCI. So that is one plus.

That whole dependency is just to get the host bridge ID which is then used
to determine tjmax. Personally I would prefer to have a wrong tjmax over not having 
coretemp at all, and the means to determine tjmax through the bridge ID is kind
of bogus anyway. So at least in this case it would make sense for me to remove
the dependency completely. Actually, we won't even change functionality,
since tjmax is only set to a higher value for specific bridge IDs.

So, if you don't mind, please re-submit with the PCI dependency removed entirely.
Unless someone starts screaming, I'll apply that to my -next tree.

Thanks,
Guenter

