Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2LKQif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:38:35 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:60149 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2LKQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:38:34 -0500
Date: Tue, 11 Dec 2012 17:38:19 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211173819.6f2cf32b@skate>
In-Reply-To: <20121211162325.GR14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
	<20121211170338.4859ddf0@skate>
	<201212111615.03262.arnd@arndb.de>
	<20121211162325.GR14363@n2100.arm.linux.org.uk>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Tue, 11 Dec 2012 16:23:25 +0000, Russell King - ARM Linux wrote:

> > * ARCH_VEXPRESS should not select NO_IOPORT. It's generally wrong
> >   to select this in combination with ARCH_MULTIPLATFORM, when some
> >   of the other platforms you may enable actually have IOPORT mapping
> >   support.
> 
> No.  ARCH_VEXPRESS selects NO_IOPORT because it _does_ _not_ support
> PCI/ISA IO space.  That in itself is reasonable, but what isn't
> reasonable is the _negative_ logic being used.  Negative logic in
> the config system always tends to provoke this kind of sillyness
> because you're selecting something to be excluded which another
> platform may require.

Could you enlighten my very naive understanding of things about PCI/ISA
IO space? On x86, I seem to understand this is the separate address
space accessed by the special in/out CPU instructions. Are there ARM
platforms with the same sort of things?

As far as I understand, on my ARM Marvell system, everything is
memory-mapped, so there isn't such a separate PCI/ISA IO space.

Therefore, why would I need to "select HAVE_IOPORT" simply to be able
to build libata-sff.c, that is used for PCI drivers that work fine with
purely memory-mapped registers?

Sorry for the stupid/naive questions, but it'll definitely help to
understand the matter.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
