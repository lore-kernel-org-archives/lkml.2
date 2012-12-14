Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2LNPI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab2LNPI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:08:56 -0500
Date: Fri, 14 Dec 2012 10:08:41 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
Message-ID: <20121214150841.GA15843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
	Jason Cooper <jason@lakedaemon.net>
References: <20121213202157.8106C66071E@gitolite.kernel.org>
 <20121213205159.GA21825@redhat.com>
 <20121214082150.GA7717@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214082150.GA7717@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 09:21:50AM +0100, Andrew Lunn wrote:
 
 > > Given this seems to be dependant on device-tree, shouldn't there be
 > > some 'depends on' in the kconfig to prevent this showing up on architectures
 > > that don't implement it ? 
 > > 
 > >  > +menuconfig POWER_RESET
 > >  > +	bool "Board level reset or power off"
 > >  > +	help
 > >  > +	  Provides a number of drivers which either reset a complete board
 > >  > +	  or shut it down, by manipulating the main power supply on the board.
 > >  > +
 > >  > +	  Say Y here to enable board reset and power off
 > >  > +
 > >  > +config POWER_RESET_GPIO
 > >  > +	bool "GPIO power-off driver"
 > >  > +	depends on OF_GPIO && POWER_RESET
 >
 > Don't these depends on here do what you want?
 
I think it needs to be on the menuconfig, rather than the child options.
I don't have OF_GPIO, but I still got asked for the former.

 
 > > If not, upon seeing this, I suspect many users will ask "how do I know if I need this?"
 > > given there's no mention of the sort of hardware this is useful on.
 > 
 > Its a generic driver. I know its useful on various Marvell kirkwood
 > and orion5x devices. I've also heard it useful on some Tegra boards.
 > 
 > Are you asking i list these boards?

No, but at least mentioning the architecture might have clued me in quicker that this
wasn't some now ACPI-ism when I saw it on x86.

	Dave

