Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1JKQBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:01:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53674 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1JKQBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:01:49 -0400
Date: Tue, 11 Oct 2011 09:01:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 2/6] MFD: twl6040: Cache the vibra control registers
Message-ID: <20111011160142.GB10286@core.coreip.homeip.net>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
 <1316760584-27426-3-git-send-email-peter.ujfalusi@ti.com>
 <20111011144824.GE1098@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011144824.GE1098@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 03:48:24PM +0100, Mark Brown wrote:
> On Fri, Sep 23, 2011 at 09:49:40AM +0300, Peter Ujfalusi wrote:
> > The vibra control register will be used from the ASoC codec driver as well.
> > In order to avoid latency issues caused by I2C read access, cache the two
> > control register within the core driver, so we do not need to reach out
> > to the chip to read it back.
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> It strikes me that it might be useful to just convert the driver to
> regmap and get cache for everything...
> 
> Anyway, could you please restructure this series to minimize the
> dependency on the input subsystem?  Then we can get the rest of it
> applied.
> 

I'm OK with all patches going through MFD - I do not believe it will
cause any merge issues.

For the record I still do not like returning EBUSY when device is not
available - I think if device can't serve any requests it should not
exists at all.

-- 
Dmitry
