Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2AIJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:59:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51580 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2AIJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:59:14 -0500
Date: Mon, 9 Jan 2012 10:59:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kernel@pengutronix.de,
        linux-serial@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Kconfig option for compile time build coverage (Was: Re: [PATCH]
 serial/efm32: add new driver)
Message-ID: <20120109095903.GC14252@pengutronix.de>
References: <20111221202847.4ffeba10@bob.linux.org.uk>
 <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <201112231035.23215.arnd@arndb.de>
 <20111223204428.GI24496@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111223204428.GI24496@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 23, 2011 at 09:44:28PM +0100, Uwe Kleine-König wrote:
> On Fri, Dec 23, 2011 at 10:35:22AM +0000, Arnd Bergmann wrote:
> > On Thursday 22 December 2011, Uwe Kleine-König wrote:
> > > [...]
> > > +config SERIAL_EFM32_USART
> > > +	bool "EFM32 USART port."
> > > +	depends on ARCH_EFM32
> > > +	select SERIAL_CORE
> [...]
> > I would generally prefer not to make the driver depend on the
> > platform, so we can get better compile time coverage. I think a better
> > set of dependencies would be
> > 
> > 	depends on HAVE_CLK
> > 	depends on OF
> > 	default ARCH_EFM32
> I'd prefer something like:
> 
> 	depends on HAVE_CLK
> 	depends on ARCH_EFM32 || I_DO_BUILD_COVERAGE_TESTING
> 
> This would make it easier for Joe User to pick the right options for his
> kernel (assuming he found out to better keep I_DO_BUILD_COVERAGE_TESTING
> disabled). [...]
What do you think about this I_DO_BUILD_COVERAGE_TESTING option? It
would allow testers to get all possible options enabled (though there
will never be an EFM32 USART port on a non-EFM32 machine I guess) and
still users and distribution packagers would easily keep the option off
even without cluttering .config and {menu,n,x,whatever}config.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
