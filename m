Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab1FJSBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:01:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46918 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107Ab1FJSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:01:41 -0400
Date: Fri, 10 Jun 2011 19:01:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [Device-drivers-devel] [alsa-devel] [PATCH 2/3] ASoC: Blackfin:
 Add bf5xx-adau1701 machine driver
Message-ID: <20110610180137.GP26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de>
 <20110610173004.GJ26441@sirena.org.uk>
 <BANLkTimBJbkYJnU5vgmo+a5eerRroE1uBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimBJbkYJnU5vgmo+a5eerRroE1uBg@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:47:34PM -0400, Mike Frysinger wrote:
> On Fri, Jun 10, 2011 at 13:30, Mark Brown wrote:

> > So, I keep on complaining about the way these drivers are just generic
> > to any random Blackfin plus CODEC combination rather than being board
> > specific.  It'd be good if we could improve this, even adding something
> > into the driver name to make it clear these are for the EVB would help.

> i know you keep complaining, but i honestly dont understand why this
> is undesirable.  connecting a codec to a Blackfin is pretty much
> always the same.  you pick a SPORT # and that's about it.

Only if you're looking at very basic boards - as soon as you start
adding any external components on the boards like speaker amps, start
handling jacks (with detection or without) or start dealing with more
flexible CODEC devices with a wider range of connection possibilities
the number of possibilities expands dramatically.

> the spi cs and i2c address could differ (so maybe make that a field
> for the platform resources), but otherwise i dont see why people
> should have to copy & paste the same code to change all of 4 bytes.

Reusing code where there's similiarities is fine - Tegra is doing that
for WM8903 based systems in a fairly tasteful fashion - but that's not
really what this stuff feels like it is doing.  For example, the SPORT
selection and reset GPIO selection should be platform data not Kconfig
options and drivers that explicitly say they're for a particular board
in Kconfig should probably say so in code also.
