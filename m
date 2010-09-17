Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0IQMHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:07:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59707 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753157Ab0IQMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:07:04 -0400
Date: Fri, 17 Sep 2010 13:07:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jeongbae Seo'" <jeongbae.seo@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        linux-arm-kernel@lists.infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] regulator: Add support samsung power domain
Message-ID: <20100917120702.GB4322@rakim.wolfsonmicro.main>
References: <1284717532-9992-1-git-send-email-kgene.kim@samsung.com>
 <20100917113050.GA4322@rakim.wolfsonmicro.main>
 <007b01cb565d$db4376d0$91ca6470$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007b01cb565d$db4376d0$91ca6470$%szyprowski@samsung.com>
X-Cookie: I can't drive 55.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 01:45:36PM +0200, Marek Szyprowski wrote:

> The approach with merging power domains with clocks have some disadvantages.
> In some cases the clock gating and power gating should be distinguished.

This is not what I suggested.  I suggested using runtime PM instead of
the regulator API to manage blocks.

> Just assume an IP like a video codec. It has it's own internal state machine.
> It gets reset when the ip is power gated, but it is preserved during clock
> gating. The driver might want to do a clock gating when it is waiting for a
> new frame to decode, but should do power gating only when the device has

There's nothing stopping the drivers enabling and disabling the clocks
for themselves while they're active, all the rumtime PM stuff I've seen
for this does is ensure that the clocks are enabled and disabled when
the device is enabled and disabled.  This matches what you're saying
above - clearly, if the device is power gated there's no need to provide
a clock for it - and with aggressive runtime PM it's pretty much exactly
what a lot of devices end up needing.

> been closed. Having a set of fake clocks just for power gating imho doesn't
> look good.

Who said use the clock API?
