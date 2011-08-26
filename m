Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1HZFDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:03:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39906 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1HZFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:03:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6449"; a="112890607"
Date: Thu, 25 Aug 2011 22:03:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 4/4] ARM: msm: Describe MSM 8660 SURF FPGA registers
 in DT
Message-ID: <20110826050303.GA23472@huya.qualcomm.com>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
 <201108251327.13146.arnd@arndb.de>
 <20110825145736.GA31331@huya.qualcomm.com>
 <201108251726.32689.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108251726.32689.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So, if I made it a separate driver, where would it go?  Since this
> > board still has platform device support, I suspect the platform data
> > needed to describe this device would end up being larger than the
> > driver itself.
> 
> Excellent question ;-)
> 
> When the driver is really small, I would just leave it in the board
> file for now, although that might not be a good long-term strategy.
> Do we have any similar cases that we can group together with the
> fpga to make a subsystem? Maybe it could be a small driver in the
> pinmux subsystem when that is established.

At this point, I think I'm just going to leave this FPGA
initialization out.  It seems that newer versions of the bootloader
have made the FPGA entirely inaccessible.  This has the unfortunate
consequence of making the UART unusable on the MSM8660 SURF.  I'll see
if I can get this fixed at a bootloader level, or come up with another
solution.

So, meanwhile, I'll include the other patches, which work fine on the
MSM 8660 Fluid target, and I'll just make an additional dsb file for
this.  Patch soon...

The FLUID has the advantage of being a device that is technically
available to people (although a bit pricey)

  http://www.bsquare.com/snapdragon-mobile-development-platform.aspx

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
