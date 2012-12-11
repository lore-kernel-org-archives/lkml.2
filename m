Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2LKRxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:53:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58463 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2LKRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:52:58 -0500
Date: Tue, 11 Dec 2012 17:51:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lior Amsalem <alior@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions
	in CONFIG_HAS_IOPORT
Message-ID: <20121211175113.GX14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com> <201212111043.50627.arnd@arndb.de> <20121211162647.GS14363@n2100.arm.linux.org.uk> <20121211171610.01c2de16@pyramind.ukuu.org.uk> <20121211173450.GW14363@n2100.arm.linux.org.uk> <20121211174509.69c8c66e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211174509.69c8c66e@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:45:09PM +0000, Alan Cox wrote:
> > The problem comes when you end up trying to deal with stuff which
> > uses ioread{8,16} on ioport_map() cookies where it's assumed that
> > adding N to the cookie is the same as adding N to the port address.
> 
> It's a cookie - this isn't a problem, you can support it via the mapping
> approah. Whether you want to is another question.

We're drifting off the topic of whether these things should be provided
and whether the config symbols should be selected...

For a kernel configuration which includes platforms where there is are no
ISA peripherals, no PCI bridge present, and no PCMCIA support, there's
little point to having IO space support present.

However, the platform should still work correctly if IO space support is
configured into the kernel (in other words, it shouldn't cause a failure)
so that such a platform can co-operate with those platforms which do
require IO space support.

Now, there was an idea a while back about having a common virtual address
space to map PCI/ISA IO space to - which we have in the kernel - 1MB at
0xfee00000.

If PCI is disabled, the ends up being a 1:1 conversion between IO offset
and CPU virtual address - that's partly there because no one's fixed up
the soc-common PCMCIA stuff to dea with the PCMCIA socket IO spaces
there.  We really need to be fixing some of this stuff...

(Unfortunately, my SA11x0 platform with the dual PCMCIA/CF sockets is now
my firewall so its out of the question to mess around with it on an ad-hoc
basis.)
