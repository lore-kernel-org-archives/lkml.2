Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098Ab0KQRbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:31:24 -0500
Received: from kroah.org ([198.145.64.141]:47892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291Ab0KQRbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:31:21 -0500
Date: Wed, 17 Nov 2010 09:31:15 -0800
From: Greg KH <greg@kroah.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] OMAP: Serial: Define register access modes in LCR
Message-ID: <20101117173115.GA12349@kroah.com>
References: <1289982712-7309-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <20101117161729.GF10992@kroah.com>
 <87hbff7tbf.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87hbff7tbf.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 09:28:52AM -0800, Kevin Hilman wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Wed, Nov 17, 2010 at 10:31:52AM +0200, Emeltchenko Andrei wrote:
> >> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> >> 
> >> Access to some registers depends on register access mode
> >> Three different modes are available for OMAP (at least)
> >> • Operational mode     LCR_REG[7] = 0x0
> >> • Configuration mode A LCR_REG[7] = 0x1 and LCR_REG[7:0]! = 0xBF
> >> • Configuration mode B LCR_REG[7] = 0x1 and LCR_REG[7:0]  = 0xBF
> >> 
> >> Define access modes and remove redefinitions and magic numbers
> >> in serial drivers (and later in bluetooth driver).
> >> 
> >> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> >> ---
> >>  arch/arm/mach-omap2/serial.c                  |   12 ++++----
> >>  arch/arm/plat-omap/include/plat/omap-serial.h |    9 ------
> >>  drivers/serial/8250.c                         |   26 +++++++++---------
> >>  drivers/serial/omap-serial.c                  |   34 ++++++++++++------------
> >>  include/linux/serial_reg.h                    |    7 +++++
> >
> > What tree should this go through?  THe omap or serial one?
> 
> Since this only affects OMAP drivers, we can take this through OMAP.
> 
> That will also help us avoid conflicts, as we'll hopefully be converting
> the omap-serial driver to runtime PM for this next merge window as well.

Fine with me, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
