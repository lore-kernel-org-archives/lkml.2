Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2IYLVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:21:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2IYLVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:21:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Date: Tue, 25 Sep 2012 11:20:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastien Requiem <sebastien@kolios.dk>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20120925121439.49c5d0dd@skate> <20120925103141.GG27099@lunn.ch>
In-Reply-To: <20120925103141.GG27099@lunn.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251120.54255.arnd@arndb.de>
X-Provags-ID: V02:K0:Pr/162Q0pfxF+NA7cP1gJQ3nfzS2H8cYxEriWW1ZZgD
 VwqVOUogtoPEQ7ETsXgp5Qc9rhnT/nZCeIWPp55IRwcEcZkSnE
 2ffOH6nspnmu9FK1VWD3KytLJUHZq/BLLy/J6cX6gHuM4CqFJX
 jm1NndvefGjBPBVpHrtGm8yFCLSitPgsyxUkRCo34zUP7z8tUz
 02NS7OkxdlChpSABs9/xuob1SBAiU0Rmk2KWDv8Hf9uZasH4U8
 NT+jf1surcSbvzUNrhLrlih69d+6VidTQl870qCaF2THPQ2vjI
 Kn+eF871JHRPJvW4OEbHRB5rg9CxWVJIJgrCvTtB6yI7sNwh+k
 BMNDiNn7z3mGqa1wzpwI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012, Andrew Lunn wrote:
> On Tue, Sep 25, 2012 at 12:14:39PM +0200, Thomas Petazzoni wrote:
> > On Tue, 25 Sep 2012 11:46:10 +0200, Andrew Lunn wrote:
> > 
> > > I principle, i agree. However, i'm not too sure about mach-orion5x &
> > > mach-mv78xx0. orion5x has probably been broken since -rc1 was released
> > > and nobody noticed. In the same time, we got around 5 people
> > > independently reporting kirkwood was broken. We have not received any
> > > new boards for orion5x in the time i've been looking at Orion
> > > platforms. mv78xx0 only has one board which is not a Marvell reference
> > > design. So im tempted to not spend any effort moving orion5x or
> > > mv78xx0 to DT unless these actually hinder the effort of moving the
> > > others to DT.  What may make sense is to flatten mv78xx0 and orion5x
> > > into plat-orion and then just watch the bit-rot happen.
> > 
> > I'll try to see if I can get people from LaCie to test mach-orion5x as
> > I have a few contacts there, and I'll contact Marvell to see if they can
> > still provide Orion-based platforms.
> 
> Marvell supplied my one one reference platform. So i can do some
> testing that the basic infrastructure works.
> 
> But the problem with converting to DT is that there is a lot of
> brainless monkey work needed per supported board, and its very easy to
> make a typo. So each board converted to DT needs testing. I don't know
> if we can find testers for all the boards. But should we throw out
> working boards just because we cannot find somebody to test the DT
> version?

We can throw them out in a staged process. I think the first step should
be ensuring that the platform support works on one (or better a few)
board reliably, and merge support for that into mach-mvebu but leave
the other ~20 board files in mach-orion5x without spending too much work
on them. Whether that means pinctrl support for mach-orion5x is a something
you need to figure out.

The next step would be to label mach-orion5x as deprecated in Kconfig for
a release and change the help text so it tells people to move to mach-mvebu
and submit dts files.

After that, we can leave mach-orion5x in the kernel for another release but
completely disable the option to enable it in Kconfig as a last warning.
This means anyone who is using it will have to move on or talk to us about
extending the transition period.

Finally, we remove mach-orion5x. Hopefully by that time, everyone who is
using it will have contributed a dts file for it.

> > Regarding mv78xx0, I agree that I'm not sure what to do. The number of
> > supported platforms is small. Should we simply mark mv78xx0 deprecated
> > now, wait a few release cycles to see if anyone shows up, and see what
> > to do at this point?

We should let Sebastien Requiem comment. He is the only person outside of
Marvell who has contributed a board file for mv78xx0. If he's interested in
keeping it alive, he's hopefully also able to find the time to test the
devicetree version of that platform in mach-mvebu. Similarly, if anyone
has the MASA reference design, that one could be moved over to mach-mvebu
first.

There is a much smaller user base for mv78xx0 than for orion5x, so as long
as we can keep the support working with DT, we can throw out the legacy
code much faster than for orion. If it doesn't get put into mach-mvebu
and you can't find anyone who has hardware to test on, you could also
stop maintaining it and leave it to bitrot, but I wouldn't just remove it
on a fast track then.

	Arnd
