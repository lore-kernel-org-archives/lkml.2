Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2LNLT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:19:29 -0500
Received: from marmot.wormnet.eu ([188.246.204.87]:52714 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2LNLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:19:28 -0500
X-Greylist: delayed 2342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 06:19:28 EST
Date: Fri, 14 Dec 2012 10:40:24 +0000 (GMT)
From: Jamie Lentin <jm@lentin.co.uk>
X-X-Sender: lentinj@marmot.wormnet.eu
To: Andrew Lunn <andrew@lunn.ch>
cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simon Baatz <gmbnomis@gmail.com>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
In-Reply-To: <20121214082150.GA7717@lunn.ch>
Message-ID: <alpine.DEB.2.00.1212141035390.25381@marmot.wormnet.eu>
References: <20121213202157.8106C66071E@gitolite.kernel.org> <20121213205159.GA21825@redhat.com> <20121214082150.GA7717@lunn.ch>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012, Andrew Lunn wrote:

> On Thu, Dec 13, 2012 at 03:51:59PM -0500, Dave Jones wrote:
>> On Thu, Dec 13, 2012 at 08:21:57PM +0000, Linux Kernel wrote:
>> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=96ff0f5c7efd4a2205c48a76a6a1fcd2731e6128
>> > Commit:     96ff0f5c7efd4a2205c48a76a6a1fcd2731e6128
>> > Parent:     f4a00139b7cbeff538e616a21f6b57249a9d3ed8
>> > Author:     Jamie Lentin <jm@lentin.co.uk>
>> > AuthorDate: Sat Nov 17 09:51:04 2012 +0100
>> > Committer:  Jason Cooper <jason@lakedaemon.net>
>> > CommitDate: Sat Nov 24 02:56:38 2012 +0000
>> >
>> >     power: Add simple poweroff-gpio driver
>> >
>> >     Given appropriate devicetree bindings, this driver registers a
>> >     pm_power_off function to set a GPIO line high/low to power down
>> >     your board.
>>
>> Given this seems to be dependant on device-tree, shouldn't there be
>> some 'depends on' in the kconfig to prevent this showing up on architectures
>> that don't implement it ?
>>
>> > +menuconfig POWER_RESET
>> > +	bool "Board level reset or power off"
>> > +	help
>> > +	  Provides a number of drivers which either reset a complete board
>> > +	  or shut it down, by manipulating the main power supply on the board.
>> > +
>> > +	  Say Y here to enable board reset and power off
>> > +
>> > +config POWER_RESET_GPIO
>> > +	bool "GPIO power-off driver"
>> > +	depends on OF_GPIO && POWER_RESET
>
> Hi Dave
>
> Don't these depends on here do what you want?
>
>> > +	help
>> > +	  This driver supports turning off your board via a GPIO line.
>> > +	  If your board needs a GPIO high/low to power down, say Y and
>> > +	  create a binding in your devicetree.
>>
>> If not, upon seeing this, I suspect many users will ask "how do I know if I need this?"
>> given there's no mention of the sort of hardware this is useful on.
>
> Its a generic driver. I know its useful on various Marvell kirkwood
> and orion5x devices. I've also heard it useful on some Tegra boards.
>
> Are you asking i list these boards?

Even if you did, it'd rapidly go out of date I suspect. How about turning 
it on it's head?

If the device tree for your board includes a gpio-poweroff node, say 
Y. Otherwise, say N. You can find the device tree in arch/*/boot/dts/

>
>    Thanks
> 	Andrew
>

-- 
Jamie Lentin
