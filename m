Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1JLJUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:20:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39746 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1JLJUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:20:15 -0400
Date: Wed, 12 Oct 2011 11:19:05 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Stephen Warren <swarren@nvidia.com>, Mikael Pettersson <mikpe@it.uu.se>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "Greg KH (gregkh@suse.de)" <gregkh@suse.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Leon Romanovsky <leon@leon.nu>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>
Subject: Re: Re: [PATCH] fix drivers/staging/nvec linkage error when keyboard
 isdisabled
Message-ID: <20111012091905.GA2713@jak-linux.org>
References: <20112.34922.209107.730268@pilspetsen.it.uu.se>
 <74CDBE0F657A3D45AFBB94109FB122FF173B23B539@HQMAIL01.nvidia.com>
 <20111010202011.GA7220@jak-linux.org>
 <1393689.vD9jATQIpt@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393689.vD9jATQIpt@fb07-iapwap2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 10:15:26AM +0200, Marc Dietrich wrote:
> Am Montag, 10. Oktober 2011, 22:20:11 schrieb Julian Andres Klode:
> > On Mon, Oct 10, 2011 at 10:25:07AM -0700, Stephen Warren wrote:
> > > Marc Dietrich wrote at Sunday, October 09, 2011 9:48 AM:
> > > > Hi Mikael,
> > > > 
> > > > thanks for review. The nvec driver received some overhaul in the 3.1
> > > > release cycle and he fruids can be viewed in linux-next tree. The nvec
> > > > client drivers were converted to mfd children in the mean time. This
> > > > solves the build error, but is not very flexible. We are planing to move
> > > > the mfd stuct to the board file(s) in the next cycle.
> > > 
> > > Indeed, the code in v3.1-rc9 is quite different to that in linux-next, so
> > > this exact problem doesn't exist in linux-next.
> > > 
> > > However, don't we still want to solve build problems for the final v3.1
> > > release, or a stable update to that? As such,
> > > 
> > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > 
> > Acked-by: Julian Andres Klode <jak@jak-linux.org>
> > 
> > But I should also add that there are probably more build failures due to
> > dependencies, as there are no dependencies specified in Kconfig (so basically
> > all nvec-* modules are subject to build failure if there dependencies
> > are not enabled (INPUT/SERIO/whatever). There's a patch in -staging
> > and -next for that, it may need adoption for 3.1 but would be needed
> > to fix all build failures.
> 
> well, I consider these as minor problems. Up to now, we have no users of the driver 
> and anyone who wants to build it should know what he does (e.g. patch a board file, 
> choose the right config).

Well yes, but that's not a reason not to fix it. For example, think about people doing
automated test building of newer kernel versions that answer yes to every new question,
their build could break.

> 
> Having said that, I want to submit a patch in the next days which adds nvec support 
> to the paz00 board file. If it's not to late for 3.2, I will also patch the nvec 
> Makefile to fix possible build problems Julian mentioned. Otherwise it will be 3.3 
> stuff.
Well, we do have a correct Kconfig in staging (as in: should not cause build
failures). The other patch you have is also slightly wrong currently, it selects
an option (LEDS_CLASS) that depends on other options


-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
