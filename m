Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2HVVnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:43:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43404 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2HVVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:43:40 -0400
Date: Wed, 22 Aug 2012 22:43:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more
	mach-*/*.h includes
Message-ID: <20120822214323.GA12255@n2100.arm.linux.org.uk>
References: <201208221253.07278.arnd@arndb.de> <201208221301.19439.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208221301.19439.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:01:19PM +0000, Arnd Bergmann wrote:
> These are lots of device drivers that include machine
> specific header files from ARM platforms and that are
> not easily scriptable. The changes have been found through
> manual inspection and should cause no visible changes
> because of the build script that maps the old names to the
> new ones.

And you end up missing a bunch of drivers in the process, such as the
sa1100 RTC driver which is shared between sa11x0 and PXA.  I wonder
how many of the Samsung platforms get broken by this as well...

In any case, what we _should_ be doing here as well is moving the headers
included by drivers for platform data out of the arch/arm/mach/ subtrees
and into include/linux/platform_data.  That will substantially reduce the
amount of mach/ headers to deal with.

Where I want this to get to is not a persistence of the existing crappy
situation where platforms stuff platform data definitions into arch/arm,
but instead put them in the right place.  That means providing them with
a good reason why the existing solution won't work, and not allowing
mach/ includes in drivers is a very good way to achieve that.
