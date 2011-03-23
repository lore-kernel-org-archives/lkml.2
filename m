Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1CWMhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:37:41 -0400
Received: from fifo99.com ([67.223.236.141]:51815 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab1CWMhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:37:39 -0400
Subject: Re: [PATCH 2/3] msm: Peripheral Image Loader (PIL) driver
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
In-Reply-To: <8ya62riucx0.fsf@huya.qualcomm.com>
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
	 <1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
	 <1300270820.13755.14.camel@desktop>  <8ya62riucx0.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 05:37:36 -0700
Message-ID: <1300883856.6117.5.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 11:40 -0700, David Brown wrote:
> On Wed, Mar 16 2011, Daniel Walker wrote:
> 
> > On Wed, 2011-03-09 at 20:44 -0800, Stephen Boyd wrote:
> >> On 8660, the modem, dsp, and sensors peripherals require their
> >> firmware to be loaded into memory before they can be properly
> >> taken out of reset.
> >> 
> >> Drivers are expected to call pil_get() when they wish to load a
> >> peripheral. This will initiate multiple firmware_request()s for
> >> the metadata and image blobs for a peripheral. Once the image has
> >> been loaded into memory, it is validated and brought out of reset
> >> via the peripheral reset driver.
> >
> > Why can't this be part of the generic firmware request API ?
> 
> Can you clarify what you mean by this?  The firmware request API is used
> to get the firmware itself, which this code uses.  This code is what
> manages making those calls for the various MSM peripherals that require
> firmware.

I'm suggesting that you make this part of a generic set of API's .

> >> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> >> index 997c5bd..25b73b0 100644
> >> --- a/arch/arm/mach-msm/Kconfig
> >> +++ b/arch/arm/mach-msm/Kconfig
> >> @@ -210,4 +210,17 @@ config IOMMU_API
> >>  
> >>  config MSM_SCM
> >>         bool
> >> +
> >> +config MSM_PIL
> >> +       bool "Peripheral image loading (PIL)"
> >> +       select FW_LOADER
> >> +       select MSM_SCM
> >> +       depends on ARCH_MSM8X60
> >> +       help
> >> +         Some peripherals need to be loaded into memory before they
> >> can be
> >> +         brought out of reset.
> >> +
> >> +         Say yes to support these devices.
> >> +
> >> +
> >
> > You shouldn't be adding anything like this to the Kconfig. To me if you
> > add stuff like this it's a big red flag.
> 
> Can you clarify what you mean "stuff like this".

I was commenting on a Kconfig option so "stuff like this" is a Kconfig
option like the one I was commenting on.

> It seems to me that this option should be selected by the drivers that
> need it, since it doesn't make sense to have this if there are no
> drivers that need it, and it is required when those drivers are
> included.

You want as few selectable Kconfig options in the mach-msm Kconfig as
possible.

Danil

