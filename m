Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1CWM1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:27:14 -0400
Received: from fifo99.com ([67.223.236.141]:46636 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1CWM1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:27:12 -0400
Subject: Re: [PATCH 2/3] msm: Peripheral Image Loader (PIL) driver
From: Daniel Walker <dwalker@fifo99.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D8105F5.1030307@codeaurora.org>
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
	 <1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
	 <1300270820.13755.14.camel@desktop> <8ya62riucx0.fsf@huya.qualcomm.com>
	 <4D8105F5.1030307@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 05:27:03 -0700
Message-ID: <1300883223.6117.1.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 11:48 -0700, Saravana Kannan wrote:
> On 03/16/2011 11:40 AM, David Brown wrote:
> > On Wed, Mar 16 2011, Daniel Walker wrote:
> >
> >> On Wed, 2011-03-09 at 20:44 -0800, Stephen Boyd wrote:
> >>> On 8660, the modem, dsp, and sensors peripherals require their
> >>> firmware to be loaded into memory before they can be properly
> >>> taken out of reset.
> >>>
> >>> Drivers are expected to call pil_get() when they wish to load a
> >>> peripheral. This will initiate multiple firmware_request()s for
> >>> the metadata and image blobs for a peripheral. Once the image has
> >>> been loaded into memory, it is validated and brought out of reset
> >>> via the peripheral reset driver.
> >>
> >> Why can't this be part of the generic firmware request API ?
> >
> > Can you clarify what you mean by this?  The firmware request API is used
> > to get the firmware itself, which this code uses.  This code is what
> > manages making those calls for the various MSM peripherals that require
> > firmware.
> >
> >>> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> >>> index 997c5bd..25b73b0 100644
> >>> --- a/arch/arm/mach-msm/Kconfig
> >>> +++ b/arch/arm/mach-msm/Kconfig
> >>> @@ -210,4 +210,17 @@ config IOMMU_API
> >>>
> >>>   config MSM_SCM
> >>>          bool
> >>> +
> >>> +config MSM_PIL
> >>> +       bool "Peripheral image loading (PIL)"
> >>> +       select FW_LOADER
> >>> +       select MSM_SCM
> >>> +       depends on ARCH_MSM8X60
> >>> +       help
> >>> +         Some peripherals need to be loaded into memory before they
> >>> can be
> >>> +         brought out of reset.
> >>> +
> >>> +         Say yes to support these devices.
> >>> +
> >>> +
> >>
> >> You shouldn't be adding anything like this to the Kconfig. To me if you
> >> add stuff like this it's a big red flag.
> >
> > Can you clarify what you mean "stuff like this".
> >
> > It seems to me that this option should be selected by the drivers that
> > need it, since it doesn't make sense to have this if there are no
> > drivers that need it, and it is required when those drivers are
> > included.
> >
> > I do think there are valid hardware configurations that don't have any
> > peripherals needing firmware, and would think that those should be able
> > to avoid requiring the code to manage that.  Saravana/Stephen can
> > clarify that, though.
> 
> Correct. There are plenty of Qualcomm SoCs that don't need this driver. 
> There are also valid 8660 configurations that would not need this.

Being a driver it shouldn't be in mach-msm.

Daniel

