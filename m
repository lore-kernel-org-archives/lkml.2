Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1HLDOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:14:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52419 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751473Ab1HLDOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:14:42 -0400
Date: Fri, 12 Aug 2011 12:14:35 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@google.com>
Cc: Stephen Warren <swarren@nvidia.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
Message-ID: <20110812031433.GE10218@opensource.wolfsonmicro.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
 <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
 <20110806084805.GA18098@sirena.org.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
 <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
 <CAMbhsRTVm+dUODDgqiekpTrrNnpo9trJNNvOQ2ETCNkneh-L-g@mail.gmail.com>
 <1313109916.19990.28.camel@finisterre.wolfsonmicro.main>
 <CAMbhsRShLvyc2XKJAL8PwR0Uj4Pnp9rVt7QyK1qAVxJ-R2PSdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRShLvyc2XKJAL8PwR0Uj4Pnp9rVt7QyK1qAVxJ-R2PSdQ@mail.gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 07:59:27PM -0700, Colin Cross wrote:
> On Thu, Aug 11, 2011 at 5:45 PM, Mark Brown

> > For example with ASoC we'd sort all the components before the ASoC card
> > without regard for their bus dependencies or any other dependencies they
> > have (eg, their regulators). Since the ASoC card is a platform device
> > it's likely to have registered early with no regard for where the buses
> > the card needs are registered. I'd expect there's a reasonable chance
> > it'll actually make things worse in the short term.

> You can't just move everything after the card, you have to move
> everything after the last device that was probed, and it only works if
> nothing depends on any of the devices that are moved.

Sorry, I said that the wrong way round due to trying to reply quickly -
the card would be the thing that moves since that's the thing that
actually does the suspend but we've *no* idea which device we need to
move it after.  Since all the function does is a direct move after or
before a single device all we can do is pick one and pray that it's the
right device.
