Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2LKRg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:36:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58434 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2LKRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:36:27 -0500
Date: Tue, 11 Dec 2012 17:34:50 +0000
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
Message-ID: <20121211173450.GW14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com> <201212111043.50627.arnd@arndb.de> <20121211162647.GS14363@n2100.arm.linux.org.uk> <20121211171610.01c2de16@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211171610.01c2de16@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:16:10PM +0000, Alan Cox wrote:
> > Correct.  If HAS_IOPORT is not selected then we are potentially missing
> > the dependent functions (because the platform has no IOPORT support) _or_
> > it does have ISA/PCI IO spaces _but_ they're not mappable via the
> > ioport_map() mechanism due to some non-linearity involved in the
> > translation.
> > 
> > To make that second point clear, that's platforms where:
> > 
> > 	ioport_map(addr + 4) != ioport_map(addr) + 4.
> 
> For inb/inw and friends this shouldn't matter.

Exactly, and you wouldn't be using inb/inw with ioport_map().

The problem comes when you end up trying to deal with stuff which
uses ioread{8,16} on ioport_map() cookies where it's assumed that
adding N to the cookie is the same as adding N to the port address.

Thankfully those platforms aren't going to be a part of the single
zImage project...
