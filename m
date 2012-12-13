Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2LMUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:52:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab2LMUw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:52:29 -0500
Date: Thu, 13 Dec 2012 15:51:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jamie Lentin <jm@lentin.co.uk>, Andrew Lunn <andrew@lunn.ch>,
        Simon Baatz <gmbnomis@gmail.com>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
Message-ID: <20121213205159.GA21825@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jamie Lentin <jm@lentin.co.uk>, Andrew Lunn <andrew@lunn.ch>,
	Simon Baatz <gmbnomis@gmail.com>,
	Jason Cooper <jason@lakedaemon.net>
References: <20121213202157.8106C66071E@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213202157.8106C66071E@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 08:21:57PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=96ff0f5c7efd4a2205c48a76a6a1fcd2731e6128
 > Commit:     96ff0f5c7efd4a2205c48a76a6a1fcd2731e6128
 > Parent:     f4a00139b7cbeff538e616a21f6b57249a9d3ed8
 > Author:     Jamie Lentin <jm@lentin.co.uk>
 > AuthorDate: Sat Nov 17 09:51:04 2012 +0100
 > Committer:  Jason Cooper <jason@lakedaemon.net>
 > CommitDate: Sat Nov 24 02:56:38 2012 +0000
 > 
 >     power: Add simple poweroff-gpio driver
 >     
 >     Given appropriate devicetree bindings, this driver registers a
 >     pm_power_off function to set a GPIO line high/low to power down
 >     your board.

Given this seems to be dependant on device-tree, shouldn't there be
some 'depends on' in the kconfig to prevent this showing up on architectures
that don't implement it ? 

 > +menuconfig POWER_RESET
 > +	bool "Board level reset or power off"
 > +	help
 > +	  Provides a number of drivers which either reset a complete board
 > +	  or shut it down, by manipulating the main power supply on the board.
 > +
 > +	  Say Y here to enable board reset and power off
 > +
 > +config POWER_RESET_GPIO
 > +	bool "GPIO power-off driver"
 > +	depends on OF_GPIO && POWER_RESET
 > +	help
 > +	  This driver supports turning off your board via a GPIO line.
 > +	  If your board needs a GPIO high/low to power down, say Y and
 > +	  create a binding in your devicetree.

If not, upon seeing this, I suspect many users will ask "how do I know if I need this?"
given there's no mention of the sort of hardware this is useful on.

	Dave

