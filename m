Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1CCPWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:22:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59096 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758218Ab1CCPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:22:21 -0500
Date: Thu, 3 Mar 2011 15:22:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 2/6] mfd: pm8xxx: Add irq support
Message-ID: <20110303152242.GB32234@opensource.wolfsonmicro.com>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
 <1299104001-5240-3-git-send-email-adharmap@codeaurora.org>
 <20110302224616.GB32325@opensource.wolfsonmicro.com>
 <4D6F1B2B.3090706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6F1B2B.3090706@codeaurora.org>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 08:38:03PM -0800, Abhijeet Dharmapurikar wrote:
> Mark Brown wrote:

> >Is it really useful to register a struct device purely for the interrupt
> >controller?  I'd have expected this to be core functionality of the
> >device.  The fact that you need to store the device at all is a bit odd
> >too as you're using the MFD API.

> This design is slightly different from other MFD drivers.
> I separated the interrupt from the core because the interrupt
> implementation for different Qualcomm pmics remains the same. On
> 8660 FFA boards for example, we have two pmic chips that have the
> same interrupt subdevice implementation (the number of interrupts
> managed by each is different). I didn't want to duplicate the exact
> code in the core driver - hence a separate interrupt driver.

Could you deal with this with a library instead?

> With that in mind, the driver has following functions
> pm8xxxx_read_root
> pm8xxxx_read_master
> pm8xxxx_read_block

> Do you still think I should change the name?

I'd suggest adding an _irq in there.
