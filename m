Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2AWBgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 20:36:31 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:48901 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2AWBga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 20:36:30 -0500
Date: Sun, 22 Jan 2012 20:36:19 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/platform: (TS-5500) revised ADC driver
Message-ID: <20120122203619.22fabe79@lenov0n>
In-Reply-To: <20120121044631.GA4143@ericsson.com>
References: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20120121044631.GA4143@ericsson.com>
Organization: Savoir-faire Linux, Inc
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, 20 Jan 2012 20:46:31 -0800,
Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> On Fri, Jan 20, 2012 at 06:43:22PM -0500, Vivien Didelot wrote:
> > Update of the ADC driver according to the Guenter Roeck's review.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > ---
> >  arch/x86/platform/ts5500/ts5500_adc.c |  228
> > +++++++++++++-------------------- 1 files changed, 89
> > insertions(+), 139 deletions(-)
> > 
> > diff --git a/arch/x86/platform/ts5500/ts5500_adc.c
> > b/arch/x86/platform/ts5500/ts5500_adc.c index fc4560f..da6decf
> > 100644 --- a/arch/x86/platform/ts5500/ts5500_adc.c
> > +++ b/arch/x86/platform/ts5500/ts5500_adc.c
> > @@ -62,57 +62,62 @@
> >  
> Hi Vivien,
> 
> This isn't really a revised driver ... it is a patch on top of the
> previous version.

True, sorry for the mistake.

> Regarding the location, I'd really like to know from the
> powers-that-be if arch/x86/platform/ts5500/
> or
> 	drivers/platform/x86
> or
> 	drivers/hwmon
> 
> would be the appropriate location for a driver like this. As
> mentioned before, my strong preference is drivers/hwmon, but I would
> like to hear from others.

We should either split every driver into corresponding subdirectories,
or put everything in a common platform directory. My first RFC patches
set has every driver separated. As they are really specific to the
platform, people seem to agree with grouping them, mainly because they
won't be shared. I changed that in the following patches sets, and X86
maintainers seemed to be ok with that.

I'm ok with both solutions, but we should all agree on one.
Maybe we should have other maintainers view on this?

> Also, I am not sure if the current approach is appropriate to start
> with. Looking at the datasheet as well as into existing kernel code,
> it appears quite likely that some kind of more or less generic MAX197
> driver exists somewhere. The existence of is_max197_installed() -
> without any calling code - is a strong indication that this is the
> case, as well as the "static" platform data in your original patch.
> It might be more appropriate to take this more or less generic
> driver, move it to drivers/hwmon, and provide - for example through
> platform data - a means to read from and write to the chip on a
> per-platform basis, ie with per-platform access functions.

You're right, it should be possible to create a generic max197 driver
and provide read/write functions through platform data. But we don't
have a max197 right now... So it can stay as a compact TS-5500 ADC
driver for the moment, and maybe we will split later. What do you think?

Thanks,

	-Vivien
