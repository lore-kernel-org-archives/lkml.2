Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2DFHtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:49:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2DFHtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:49:15 -0400
Date: Fri, 6 Apr 2012 15:49:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120406074942.GO7264@S2101-09.ap.freescale.net>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 07:58:40PM +0100, Mark Brown wrote:
> The AMBA bus regulator support is being used to model on/off switches
> for power domains which isn't terribly idiomatic for modern kernels with
> the generic power domain code and creates integration problems on platforms
> which don't use regulators for their power domains as it's hard to tell
> the difference between a regulator that is needed but failed to be provided
> and one that isn't supposed to be there (though DT does make that easier).
> 
> Platforms that wish to use the regulator API to manage their power domains
> can indirect via the power domain interface.
> 
> This feature is only used with the vape supply of the db8500 PRCMU
> driver which supplies the UARTs and MMC controllers, none of which have
> support for managing vcore at runtime in mainline (only pl022 SPI
> controller does).  Update that supply to have an always_on constraint
> until the power domain support for the system is updated so that it is
> enabled for these users, this is likely to have no impact on practical
> systems as probably at least one of these devices will be active and
> cause AMBA to hold the supply on anyway.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Tested-by: Shawn Guo <shawn.guo@linaro.org>

Russell,

I believe this patch fixes the amba probe failure that impacts any
AMBA platform build with CONFIG_REGULATOR enabled.  Could you consider
to send the fix for -rc soon?

The patch "ARM: amba: adapt to regulator probe deferral change" from
me could be ignored now.

-- 
Regards,
Shawn
