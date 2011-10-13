Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1JMSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:38:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56670 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1JMSi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:38:26 -0400
Date: Thu, 13 Oct 2011 12:38:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        b-cousson@ti.com, patches@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111013183821.GN18574@ponder.secretlab.ca>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111010172222.GG3607@opensource.wolfsonmicro.com>
 <4E93DB41.2080900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E93DB41.2080900@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:29:29AM +0530, Rajendra Nayak wrote:
> On Monday 10 October 2011 10:52 PM, Mark Brown wrote:
> >On Mon, Oct 10, 2011 at 09:49:36PM +0530, Rajendra Nayak wrote:
> >
> >>+- regulator-change-voltage: boolean, Output voltage can be changed by software
> >>+- regulator-change-current: boolean, Output current can be chnaged by software
> >>+- regulator-change-mode: boolean, Operating mode can be changed by software
> >>+- regulator-change-status: boolean, Enable/Disable control for regulator exists
> >>+- regulator-change-drms: boolean, Dynamic regulator mode switching is enabled
> >>+- regulator-mode-fast: boolean, allow/set fast mode for the regulator
> >>+- regulator-mode-normal: boolean, allow/set normal mode for the regulator
> >>+- regulator-mode-idle: boolean, allow/set idle mode for the regulator
> >>+- regulator-mode-standby: boolean, allow/set standby mode for the regulator
> >>+- regulator-input-uV: Input voltage for regulator when supplied by another regulator
> >>+- regulator-always-on: boolean, regulator should never be disabled
> >
> >Thinking about this I'm not sure that these should go in the device
> >tree, they're as much talking about what Linux is able to cope with as
> >they are talking about what the hardware is able to do.  Sometimes
> >they'll be fixed by the design but they are sometimes also restricted by
> >what the software is currently capable of.  DRMS is a prime example
> >here, it depends on how good we are at telling the API about how much
> >current we're using.
> 
> So is there another way of passing these, if not through device tree?
> There are other linux specific things that need to be passed to the
> framework as well, like the state of the regulator in the various
> linux specific suspend states, like standby/mem/disk.
> So if these can't be passed through device tree, should they still
> be passed in some way through platform_data? Or is it best to identify
> the bindings as being linux specific and not generic by appending a
> "linux," to the bindings.
> 
> Grant, need some help and advice.
> 

I can't really help much here.  If it is a property of the hardware,
then it absolutely needs to be in the device tree.  If it is a
limitation of Linux, or the Linux driver, then I would say that it
should be encoded in the driver.  I don't understand enough of the
problem space of regulators to give a good answer about what you
should do.

These *sound* like flags that the driver would set based on its own
capabilities; in which case it is something that would be encoded
directly into the driver.

g.
