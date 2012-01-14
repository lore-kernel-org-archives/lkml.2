Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab2ANF3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:29:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47905 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2ANF3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:29:48 -0500
Date: Sat, 14 Jan 2012 13:40:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Jamie Iles <jamie@jamieiles.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20120114054043.GA3073@S2101-09.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20120110213338.GD3226@page>
 <CACxGe6vqb8AZcZb5WMvfmLsUZH7=SEtBrJCSfsFmDYpKX42MzA@mail.gmail.com>
 <20120113124659.GA17029@S2101-09.ap.freescale.net>
 <CAJOA=zNGM=743zyantezVk-5q_VmJc92iGBGR8fQM4LY5jxMVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zNGM=743zyantezVk-5q_VmJc92iGBGR8fQM4LY5jxMVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 08:30:30PM -0800, Turquette, Mike wrote:
...
> I had envisioned fixed clocks as being clocks whose rates could never
> change; obviously this is mostly useful for root clocks like
> oscillators and whatnot.
> 
> There is nothing wrong with using fixed clock for sgtl5000-sys-mclk,
> but it's rate *can* change if it's parent rate ever changes.  This may
> be very unlikely on your platform, in which case again it is OK to use
> fixed clock here if you want to.
> 
> However... I'm inclined to say that sgtl5000-sys-mclk is good
> candidate for a dummy clock: it follows it's parent rate, doesn't
> gate, doesn't divide it's parent rate, only has one input.  There
> isn't a common dummy clock in the v4 patches, but there is in v5.  The
> key difference between the fixed rate clock and the dummy clock is
> that the dummy clock looks at clk->parent->rate in it's .get_rate,
> whereas a fixed rate clock will have it's rate cached in struct
> clk_fixed.
> 
> Thoughts?
> 
I would say this modeling looks all sane to me, except both the
fixed-clock soc-26m-clk and dummy-clock sgtl5000-sys-mclk in this
case have a gate which is controlled by gpio.

-- 
Regards,
Shawn
