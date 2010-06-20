Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0FTSbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:31:35 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62866 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968Ab0FTSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:31:34 -0400
Message-ID: <4C1E5E5D.5020805@metafoo.de>
Date: Sun, 20 Jun 2010 20:30:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Graham Gower <graham.gower@gmail.com>
Subject: Re: [PATCH v2 00/26] Add support for the Ingenic JZ4740 System-on-a-Chip
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <4C1E467D.5030204@metafoo.de> <20100620170111.GA8650@alpha.franken.de> <201006201957.56978.florian@openwrt.org>
In-Reply-To: <201006201957.56978.florian@openwrt.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Florian Fainelli wrote:
> Hi,
>
> Le Sunday 20 June 2010 19:01:11, Thomas Bogendoerfer a écrit :
>> On Sun, Jun 20, 2010 at 06:49:01PM +0200, Lars-Peter Clausen wrote:
>>> different to JZ4750 and JZ4760. So JZ47xx wont fit either.
>>> Right now there is no practical use to moving things around, and there
>>> wont be until somebody who can actually test it starts adding support
>>> for a different JZ47XX SoC.
>> great, I like such attitude:-(
>
> I have to agree with Thomas here, if your concern is about the naming,
then
> just have a look at the vendor sources and find similarities for what
is worth
> being named JZ47XX and what deserves a name which is more specific.
Also, it is
> much easier to do that factoring job now instead of when there will be
3 or
> more flavors of that SoC to be supported.
Well, it's not like somebody who wants to add support for e.g. JZ4730
would start from scratch and add a complete implementation which then
has to be merged with JZ4740. You would start adding it on-top of the
existing JZ4740 platform support and generalize it where necessary.
Renaming is cheap! This is not part of an API thats set into stone...
Seriously, it doesn't make any sense to waste time and try to
generalize now while it is uncertain if there will be support of a
different JZ47xx SoC anytime soon. Furthermore the likelihood of over-
or under-generalizing is pretty high if you do not know exactly what
you want or what you need.
I strongly disagree that it is easier to do the factoring job now. It
will be easier when you actually know what requirements you'll have
based on hard facts instead of having some loose ideas of what might
work and what not.

That said, the platform support has been designed with having the idea
of support for multiple JZ47XX SoCs at some point. So it will mostly
be picking up the components shared between different SoCs and put
them in a shared folder (and maybe do a 's/jz4740/jz47xx/g'). But
right now there is only JZ4740 support...

- - Lars



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkweXl0ACgkQBX4mSR26RiM7hACfRMhD54TJEdI11AgsaaWRiDaK
xrYAnRR+0VT3CurJm2Xc9DgC9+bcrFfv
=SFR2
-----END PGP SIGNATURE-----

