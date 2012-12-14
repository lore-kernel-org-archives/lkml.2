Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2LNQNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:13:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33998 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab2LNQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:13:11 -0500
Message-ID: <50CB5014.6030004@wwwdotorg.org>
Date: Fri, 14 Dec 2012 09:13:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
References: <20121213202157.8106C66071E@gitolite.kernel.org> <20121213205159.GA21825@redhat.com> <20121214082150.GA7717@lunn.ch> <20121214150841.GA15843@redhat.com>
In-Reply-To: <20121214150841.GA15843@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 08:08 AM, Dave Jones wrote:
> On Fri, Dec 14, 2012 at 09:21:50AM +0100, Andrew Lunn wrote:
>  
>  > > Given this seems to be dependant on device-tree, shouldn't there be
>  > > some 'depends on' in the kconfig to prevent this showing up on architectures
>  > > that don't implement it ? 
>  > > 
>  > >  > +menuconfig POWER_RESET
>  > >  > +	bool "Board level reset or power off"
>  > >  > +	help
>  > >  > +	  Provides a number of drivers which either reset a complete board
>  > >  > +	  or shut it down, by manipulating the main power supply on the board.
>  > >  > +
>  > >  > +	  Say Y here to enable board reset and power off
>  > >  > +
>  > >  > +config POWER_RESET_GPIO
>  > >  > +	bool "GPIO power-off driver"
>  > >  > +	depends on OF_GPIO && POWER_RESET
>  >
>  > Don't these depends on here do what you want?
>  
> I think it needs to be on the menuconfig, rather than the child options.
> I don't have OF_GPIO, but I still got asked for the former.

The menuconfig enables a class of drivers (at least theoretically in the
future, when more such drivers turn up), and there's no reason to
believe that all of those drivers will depend on OF. So in my opinion,
making POWER_RESET_GPIO depend on OF makes sense, but making POWER_RESET
depend on it doesn't.

Another solution might be to remove the menuconfig, and just include the
option for the individual driver.
