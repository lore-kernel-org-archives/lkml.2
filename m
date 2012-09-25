Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2IYJq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:46:27 -0400
Received: from londo.lunn.ch ([80.238.139.98]:44679 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab2IYJq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:46:26 -0400
Date: Tue, 25 Sep 2012 11:46:10 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Message-ID: <20120925094610.GF27099@lunn.ch>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1348531338-16624-6-git-send-email-sebastian.hesselbarth@gmail.com>
 <20120925053542.GK14266@lunn.ch>
 <5061754E.9050204@gmail.com>
 <20120925111826.6f4086ee@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925111826.6f4086ee@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:18:26AM +0200, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
> 
> On Tue, 25 Sep 2012 11:11:42 +0200, Sebastian Hesselbarth wrote:
> 
> > I didn't try to post all the dove on mach-mvebu patches in the current
> > release cycle, because mach-mvebu is still evolving to fast for me to keep
> > up with my limited spare time. But I have dove running on mach-mvebu...
> 
> Yes, this work is really great. However, I think that instead of making
> a big change at once, we should rather follow something like:
> 
>  * Make mach-dove, mach-kirkwood, mach-orion5x, mach-mv78xx0 use the
>    new gpio/pinctrl code

I principle, i agree. However, i'm not too sure about mach-orion5x &
mach-mv78xx0. orion5x has probably been broken since -rc1 was released
and nobody noticed. In the same time, we got around 5 people
independently reporting kirkwood was broken. We have not received any
new boards for orion5x in the time i've been looking at Orion
platforms. mv78xx0 only has one board which is not a Marvell reference
design. So im tempted to not spend any effort moving orion5x or
mv78xx0 to DT unless these actually hinder the effort of moving the
others to DT.  What may make sense is to flatten mv78xx0 and orion5x
into plat-orion and then just watch the bit-rot happen.

I have patches which convert all existing DT based kirkwood boards to
the new gpio/pinctrl code. There are two outstanding issues:

1) I've no idea which kirkwood variant each board uses. Hence the
   compatibility string will be wrong for a lot of them.

2) I'm probably made lots of dumb typos.

So we need to get board maintainers to complete and test the work.

>  * Refactor the PCI code so that it can cover all cases. We should soon
>    be working on PCI support on Armada 370/XP, so it will show what are
>    the differences/issues in having something that covers all cases.

Have you looked at the orion5x PCI code? Its very different to all the
others and i doubt it will be easy to make work with all the others.

       Andrew
