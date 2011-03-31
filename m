Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1CaQeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:34:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49789 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1CaQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:34:22 -0400
Date: Thu, 31 Mar 2011 10:34:19 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, John Williams <john.williams@petalogix.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110331163419.GH26709@ponder.secretlab.ca>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <20110331124925.GA2202@pengutronix.de>
 <AANLkTinJrG=s3Xuvf_=bNtYF-z8u+YXvd217UKKz24ik@mail.gmail.com>
 <201103311525.52396.arnd@arndb.de>
 <4D9486E4.9030006@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9486E4.9030006@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 03:51:32PM +0200, Michal Simek wrote:
> Arnd Bergmann wrote:
> >On Thursday 31 March 2011, John Williams wrote:
> >>On Thu, Mar 31, 2011 at 10:49 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> >>>On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
> >>>>Support OF support. "generic-uio" compatible property is used.
> >>>And exactly this was the issue last time (when I tried). This is a
> >>>generic property, which is linux-specific and not describing HW. The
> >>>agreement back then was to we probably need to add compatible-entries at
> >>>runtime (something like new_id for USB). So the uio-of-driver could be
> >>>matched against any device. Otherwise, we would collect a lot of
> >>>potential entries like "vendor,special-card1". Although I wonder
> >>>meanwhile if it is really going to be that bad; we don't have so much
> >>>UIO-driver in tree as well. Maybe worth a try?
> >>
> >>Maybe I misunderstand you, in my view it is the responsibility of
> >><vendor> to create their DTS files to indicate they want
> >><special-card1> to bind to generic-uio.
> >>
> >>So, no great list of compat strings should grow in the driver, but
> >>rather the user of the driver must make it happen.
> >>
> >>Am I missing something?
> >
> >We try to make the device tree on describe the present hardware,
> >but not relate to how it is used.
> >
> >There are certainly cases where a specific piece of hardware can
> >be used either by a kernel-only driver or the UIO driver with a
> >user backend. I would argue that you should be able to use an
> >identical device tree for both cases, because the hardware is
> >the same. Chosing which driver to use can be either in the realm
> >of the kernel, or even user policy.
> 
> ok. What about to keep of_device_id empty?  Then there is compatible
> property string and everybody can choose what wants.
> OF is just a different driver initialization method but it is in the
> same category which is supported right now which is initialization
> through platform_device structure.

I'm not completely sure I understand what you're suggesting here.
Yes, of_device_id can be left unpopulated, but then you need to make
sure another method is available for binding the driver.

hmmmm....

You could see if the manual 'bind/unbind' platform_bus sysfs
attributes would do the job for you (see drivers/base/bus.c).  You'd
need some mechanism to force the generic-uio driver to accept the
device.

g.

