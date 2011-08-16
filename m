Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1HPR5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:57:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63638 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1HPR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:57:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110729668"
Date: Tue, 16 Aug 2011 10:57:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/4] msm_serial: Add devicetree support
Message-ID: <20110816175702.GA27576@huya.qualcomm.com>
References: <1313190008-7551-1-git-send-email-davidb@codeaurora.org>
 <1434305.ibxmc6q715@wuerfel>
 <20110813194645.GA23710@huya.qualcomm.com>
 <65679699.l4XXDScc0T@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65679699.l4XXDScc0T@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 11:34:15PM +0200, Arnd Bergmann wrote:
> On Saturday 13 August 2011 12:46:45 David Brown wrote:
> > 
> > I'm not sure actually what is best to use here.  I'm thinking that the
> > 'lite' identifier should perhaps go away.  MSM's have two UARTS on
> > them, an older "simple" PIO type of UART, and a newer one that can do
> > DMA (called the hsuart for high-speed).  The hsuart can also be used
> > in a non-DMA driver in a mostly compatible way with the old UART.
> > 
> > For non-high-speed applications, the user will probably just want to
> > use the non-DMA driver.  My question is then: if the device tree
> > describes it as
> > 
> >         compatible = "qcom,msm-hsuart", "qcom,msm-uart";
> > 
> > and one driver matches qcom,msm-hsuart and another matches
> > qcom,msm-uart, which driver will get used.  Ideally, it would use the
> > earliest one in the list.
> > 
> > If that's the case, I'll get rid of the -lite suffix and just make the
> > non-DMA driver compatible with the plain "qcom,msm-uart".
> 
> I believe that unfortunately the answer is that the first driver that
> matches anything will get used. There are two possible ways that I can
> see to make it do what you want anyway:
> 
> 1. In the probe function for the slow driver, you return an error
> when the device you get passed matches "qcom,msm-hsuart", possibly
> dependent on whether the other driver also got built.
> 
> 2. You register one platform driver that handles both names and
> gives the device to just one of the two drivers. This would probably
> require linking the two drivers into the same module, or having
> the non-DMA speed driver just act as a library.

How about if I just keep it simple for now.  Since there isn't
actually a driver for the DMA version, this driver will handle both
UART blocks, so I'll just do the plain thing in the DT.

In the future, when a DMA-capable driver exists, we can figure out how
to determine which driver should be used.  At this point, I'm not even
sure what the correct answer will be, since a given configuration may
want to use non-DMA for one msm-hsuart device, and the DMA driver for
another.  It's kind of board/use specific, but beyond just describing
what the hardware is.

I've just sent new patches with this fixed up.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
