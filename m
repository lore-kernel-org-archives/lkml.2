Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1ITQvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:51:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15810 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1ITQvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:51:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 20 Sep 2011 09:51:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>
Date: Tue, 20 Sep 2011 09:51:08 -0700
Subject: RE: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Topic: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Index: AcxipYooKUwOWBpMSfeE5QkubxGA9gEi65QgBCD9ZbA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B73215C9@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	<CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	<20110806084805.GA18098@sirena.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
	<CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
	<CAMbhsRTVm+dUODDgqiekpTrrNnpo9trJNNvOQ2ETCNkneh-L-g@mail.gmail.com>
	<1313109916.19990.28.camel@finisterre.wolfsonmicro.main>
	<CAMbhsRShLvyc2XKJAL8PwR0Uj4Pnp9rVt7QyK1qAVxJ-R2PSdQ@mail.gmail.com>
	<20110812031433.GE10218@opensource.wolfsonmicro.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3CA6@HQMAIL01.nvidia.com>
 <CAMbhsRRRa_JV8_LHEvsM2h3e8Hbf1GAcpXz8gdU3wCc8Jgz5gw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B3279D4F@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Tuesday, August 30, 2011 10:25 AM:
> Ben, Arnd,
> 
> Could you please ack/nack the patch at the start of this thread for Colin;
> see below.

Ben, can you please comment on the acceptability of this patch?

Or Arnd, did Mark's most recent explanation of the situation provide enough
context for you to ack/nak it?

Thanks.

> Thanks.
> 
> Colin Cross wrote at Wednesday, August 24, 2011 3:34 PM:
> > On Wed, Aug 24, 2011 at 2:28 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > > Mark Brown wrote at Thursday, August 11, 2011 9:15 PM:
> > >> On Thu, Aug 11, 2011 at 07:59:27PM -0700, Colin Cross wrote:
> > >> > On Thu, Aug 11, 2011 at 5:45 PM, Mark Brown
> > >>
> > >> > > For example with ASoC we'd sort all the components before the ASoC card
> > >> > > without regard for their bus dependencies or any other dependencies they
> > >> > > have (eg, their regulators). Since the ASoC card is a platform device
> > >> > > it's likely to have registered early with no regard for where the buses
> > >> > > the card needs are registered. I'd expect there's a reasonable chance
> > >> > > it'll actually make things worse in the short term.
> > >>
> > >> > You can't just move everything after the card, you have to move
> > >> > everything after the last device that was probed, and it only works if
> > >> > nothing depends on any of the devices that are moved.
> > >>
> > >> Sorry, I said that the wrong way round due to trying to reply quickly -
> > >> the card would be the thing that moves since that's the thing that
> > >> actually does the suspend but we've *no* idea which device we need to
> > >> move it after.  Since all the function does is a direct move after or
> > >> before a single device all we can do is pick one and pray that it's the
> > >> right device.
> > >
> > > Colin,
> > >
> > > This thread seems to have died down; how should we make progress?
> > >
> > > It sounds like the suspend_irq solution is the current de-facto standard;
> > > not optimal, but all we really have right now and already in use. I could
> > > certainly see avoiding this solution if it was the first time it was
> > > employed, but re-using it seems reasonable to me?
> > >
> > > Alternatively, are you attending either Linux Plumbers Conference or the
> > > Kernel Summit? Mark implied this topic might well come up for discussion
> > > there. Unfortunately, I won't be able to make LPC due to a conflict.
> > I don't think I'll be able to make it.
> >
> > > (and you'd mentioned having the subsystem maintainers weigh in on this;
> > > which sub-system; IRQ, power, I2C, ...?)
> >
> > If Ben says its OK, its fine with me.  Or maybe Arnd wants to weigh in?

--
nvpublic

