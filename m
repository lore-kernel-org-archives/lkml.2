Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab2AWEib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:38:31 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38663 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2AWEia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:38:30 -0500
Date: Sun, 22 Jan 2012 20:36:46 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/platform: (TS-5500) revised ADC driver
Message-ID: <20120123043645.GA14660@ericsson.com>
References: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120121044631.GA4143@ericsson.com>
 <20120122203619.22fabe79@lenov0n>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120122203619.22fabe79@lenov0n>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 08:36:19PM -0500, Vivien Didelot wrote:
> Hi Guenter,
> 
> On Fri, 20 Jan 2012 20:46:31 -0800,
> Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > On Fri, Jan 20, 2012 at 06:43:22PM -0500, Vivien Didelot wrote:
> > > Update of the ADC driver according to the Guenter Roeck's review.
> > > 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > ---
> > >  arch/x86/platform/ts5500/ts5500_adc.c |  228
> > > +++++++++++++-------------------- 1 files changed, 89
> > > insertions(+), 139 deletions(-)
> > > 
> > > diff --git a/arch/x86/platform/ts5500/ts5500_adc.c
> > > b/arch/x86/platform/ts5500/ts5500_adc.c index fc4560f..da6decf
> > > 100644 --- a/arch/x86/platform/ts5500/ts5500_adc.c
> > > +++ b/arch/x86/platform/ts5500/ts5500_adc.c
> > > @@ -62,57 +62,62 @@
> > >  
> > Hi Vivien,
> > 
> > This isn't really a revised driver ... it is a patch on top of the
> > previous version.
> 
> True, sorry for the mistake.
> 
> > Regarding the location, I'd really like to know from the
> > powers-that-be if arch/x86/platform/ts5500/
> > or
> > 	drivers/platform/x86
> > or
> > 	drivers/hwmon
> > 
> > would be the appropriate location for a driver like this. As
> > mentioned before, my strong preference is drivers/hwmon, but I would
> > like to hear from others.
> 
> We should either split every driver into corresponding subdirectories,
> or put everything in a common platform directory. My first RFC patches
> set has every driver separated. As they are really specific to the
> platform, people seem to agree with grouping them, mainly because they
> won't be shared. I changed that in the following patches sets, and X86
> maintainers seemed to be ok with that.
> 
> I'm ok with both solutions, but we should all agree on one.
> Maybe we should have other maintainers view on this?
> 
That is what I had asked for. I thought the whole point of per-module 
directories was to have all drivers there. If that is no longer true,
fine with me; who am I to argue about something like that.
I'd just like to know.

> > Also, I am not sure if the current approach is appropriate to start
> > with. Looking at the datasheet as well as into existing kernel code,
> > it appears quite likely that some kind of more or less generic MAX197
> > driver exists somewhere. The existence of is_max197_installed() -
> > without any calling code - is a strong indication that this is the
> > case, as well as the "static" platform data in your original patch.
> > It might be more appropriate to take this more or less generic
> > driver, move it to drivers/hwmon, and provide - for example through
> > platform data - a means to read from and write to the chip on a
> > per-platform basis, ie with per-platform access functions.
> 
> You're right, it should be possible to create a generic max197 driver
> and provide read/write functions through platform data. But we don't
> have a max197 right now... So it can stay as a compact TS-5500 ADC
> driver for the moment, and maybe we will split later. What do you think?
> 
I am lost. If you don't have a TS-5500 with max197, how do you test
the driver ?

I had another look into the MAX197 and TS-5500 data sheets. In my opinion,
a generic MAX197 driver in drivers/hwmon combined with a platform
driver in the current location would be the way to go. That driver would
then also work for the other TS-5x00 systems. All you need is a single
chip access function in the platform code, since the chip is always accessed
with a write followed by a read.

If you don't have a system with max197 available to test the driver, you can
not test the current driver either, and there is nothing you can do anyway,
and you can as well wait with the adc code until you have one.

Thanks,
Guenter
