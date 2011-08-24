Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1HXWgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:36:24 -0400
Received: from mail-qy0-f198.google.com ([209.85.216.198]:58862 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1HXWgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:36:23 -0400
X-Greylist: delayed 3310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 18:36:22 EDT
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3CA6@HQMAIL01.nvidia.com>
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
Date: Wed, 24 Aug 2011 14:33:59 -0700
Message-ID: <CAMbhsRRRa_JV8_LHEvsM2h3e8Hbf1GAcpXz8gdU3wCc8Jgz5gw@mail.gmail.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
From: Colin Cross <ccross@google.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 2:28 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Mark Brown wrote at Thursday, August 11, 2011 9:15 PM:
>> On Thu, Aug 11, 2011 at 07:59:27PM -0700, Colin Cross wrote:
>> > On Thu, Aug 11, 2011 at 5:45 PM, Mark Brown
>>
>> > > For example with ASoC we'd sort all the components before the ASoC card
>> > > without regard for their bus dependencies or any other dependencies they
>> > > have (eg, their regulators). Since the ASoC card is a platform device
>> > > it's likely to have registered early with no regard for where the buses
>> > > the card needs are registered. I'd expect there's a reasonable chance
>> > > it'll actually make things worse in the short term.
>>
>> > You can't just move everything after the card, you have to move
>> > everything after the last device that was probed, and it only works if
>> > nothing depends on any of the devices that are moved.
>>
>> Sorry, I said that the wrong way round due to trying to reply quickly -
>> the card would be the thing that moves since that's the thing that
>> actually does the suspend but we've *no* idea which device we need to
>> move it after.  Since all the function does is a direct move after or
>> before a single device all we can do is pick one and pray that it's the
>> right device.
>
> Colin,
>
> This thread seems to have died down; how should we make progress?
>
> It sounds like the suspend_irq solution is the current de-facto standard;
> not optimal, but all we really have right now and already in use. I could
> certainly see avoiding this solution if it was the first time it was
> employed, but re-using it seems reasonable to me?
>
> Alternatively, are you attending either Linux Plumbers Conference or the
> Kernel Summit? Mark implied this topic might well come up for discussion
> there. Unfortunately, I won't be able to make LPC due to a conflict.
I don't think I'll be able to make it.

> (and you'd mentioned having the subsystem maintainers weigh in on this;
> which sub-system; IRQ, power, I2C, ...?)

If Ben says its OK, its fine with me.  Or maybe Arnd wants to weigh in?
