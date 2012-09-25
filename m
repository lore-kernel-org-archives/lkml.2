Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2IYKOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:14:55 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:50974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2IYKOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:14:54 -0400
Date: Tue, 25 Sep 2012 12:14:39 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Message-ID: <20120925121439.49c5d0dd@skate>
In-Reply-To: <20120925094610.GF27099@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
	<20120925053542.GK14266@lunn.ch>
	<5061754E.9050204@gmail.com>
	<20120925111826.6f4086ee@skate>
	<20120925094610.GF27099@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Tue, 25 Sep 2012 11:46:10 +0200, Andrew Lunn wrote:

> I principle, i agree. However, i'm not too sure about mach-orion5x &
> mach-mv78xx0. orion5x has probably been broken since -rc1 was released
> and nobody noticed. In the same time, we got around 5 people
> independently reporting kirkwood was broken. We have not received any
> new boards for orion5x in the time i've been looking at Orion
> platforms. mv78xx0 only has one board which is not a Marvell reference
> design. So im tempted to not spend any effort moving orion5x or
> mv78xx0 to DT unless these actually hinder the effort of moving the
> others to DT.  What may make sense is to flatten mv78xx0 and orion5x
> into plat-orion and then just watch the bit-rot happen.

I'll try to see if I can get people from LaCie to test mach-orion5x as
I have a few contacts there, and I'll contact Marvell to see if they can
still provide Orion-based platforms.

Regarding mv78xx0, I agree that I'm not sure what to do. The number of
supported platforms is small. Should we simply mark mv78xx0 deprecated
now, wait a few release cycles to see if anyone shows up, and see what
to do at this point?

> I have patches which convert all existing DT based kirkwood boards to
> the new gpio/pinctrl code. There are two outstanding issues:
> 
> 1) I've no idea which kirkwood variant each board uses. Hence the
>    compatibility string will be wrong for a lot of them.
> 
> 2) I'm probably made lots of dumb typos.
> 
> So we need to get board maintainers to complete and test the work.

Agreed. If some don't answer, we could consider dropping support for
those boards. If people show up again later, it is still possible to
get through the git history and revive one particular board. But we
can't, and shouldn't be forced to remain in the past due to
unmaintained platforms, IMO.

> >  * Refactor the PCI code so that it can cover all cases. We should
> > soon be working on PCI support on Armada 370/XP, so it will show
> > what are the differences/issues in having something that covers all
> > cases.
> 
> Have you looked at the orion5x PCI code? Its very different to all the
> others and i doubt it will be easy to make work with all the others.

No, I haven't looked seriously at the PCI code for the moment. I should
have the opportunity to do so at some point.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
