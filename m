Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2LKQD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:03:56 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:59780 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2LKQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:03:55 -0500
Date: Tue, 11 Dec 2012 17:03:38 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211170338.4859ddf0@skate>
In-Reply-To: <201212111043.50627.arnd@arndb.de>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Tue, 11 Dec 2012 10:43:49 +0000, Arnd Bergmann wrote:
> On Friday 07 December 2012, Thomas Petazzoni wrote:
> > The pcim_*() functions are used by the libata-sff subsystem, and this
> > subsystem is used for many SATA drivers on ARM platforms that do not
> > necessarily have I/O ports.
> 
> I think this one is wrong as the CONFIG_HAS_IOPORT does not refer to the
> presence of PIO ports but to whether or not they provide an ioport_map
> function. If there is no ioport_map(), devm_pci_iomap will fail to link
> as far as I can tell.

The problem is that on ARCH_MULTI_V7, ARCH_VEXPRESS is forcefully
enabled. And ARCH_VEXPRESS selects NO_IOPORT.. so you don't have the
pcim_*() functions, and therefore libata-sff.c (needed for many SATA
drivers) will not build. How do you solve this?

I'm not sure which devm_pci_iomap() you're referring to since my patch
makes only the pcim_iomap_table(), pcim_iomap(), pcim_iounmap(),
pcim_iomap_regions(), pcim_iomap_regions_request_all() and
pcim_iounmap_regions() available under CONFIG_PCI instead of CONFIG_PCI
&& CONFIG_HAS_IOPORT.

So maybe you were referring to pcim_iomap(). I haven't checked in
details, but I guess it builds because ioport_map() is implemented in
arch/arm/mm/iomap.c.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
