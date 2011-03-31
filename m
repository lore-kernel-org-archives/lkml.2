Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab1CaN0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:26:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab1CaN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:26:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Date: Thu, 31 Mar 2011 15:25:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu> <20110331124925.GA2202@pengutronix.de> <AANLkTinJrG=s3Xuvf_=bNtYF-z8u+YXvd217UKKz24ik@mail.gmail.com>
In-Reply-To: <AANLkTinJrG=s3Xuvf_=bNtYF-z8u+YXvd217UKKz24ik@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311525.52396.arnd@arndb.de>
X-Provags-ID: V02:K0:VlTp4czO5cZRawlX+GaIUm4ibuE7uUq+7h6ebE2FxK4
 YRHM+DzpHCHAEZE0qZKugXL6cksUgzTGUobTh5E7AhuvXOR08D
 tKw6FJRH5JnQ8CW6QyfYluW00EDYEZUN1dIF79qpttycA0mk5E
 rnSausxrlsZ7Ds3uUd+deksglr1MXY0VnGKT2rc5mxt4m7ioq5
 cCQrKtFzUexrYiserf/Xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, John Williams wrote:
> On Thu, Mar 31, 2011 at 10:49 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> >
> > On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
> > > Support OF support. "generic-uio" compatible property is used.
> >
> > And exactly this was the issue last time (when I tried). This is a
> > generic property, which is linux-specific and not describing HW. The
> > agreement back then was to we probably need to add compatible-entries at
> > runtime (something like new_id for USB). So the uio-of-driver could be
> > matched against any device. Otherwise, we would collect a lot of
> > potential entries like "vendor,special-card1". Although I wonder
> > meanwhile if it is really going to be that bad; we don't have so much
> > UIO-driver in tree as well. Maybe worth a try?
> 
> 
> Maybe I misunderstand you, in my view it is the responsibility of
> <vendor> to create their DTS files to indicate they want
> <special-card1> to bind to generic-uio.
> 
> So, no great list of compat strings should grow in the driver, but
> rather the user of the driver must make it happen.
> 
> Am I missing something?

We try to make the device tree on describe the present hardware,
but not relate to how it is used.

There are certainly cases where a specific piece of hardware can
be used either by a kernel-only driver or the UIO driver with a
user backend. I would argue that you should be able to use an
identical device tree for both cases, because the hardware is
the same. Chosing which driver to use can be either in the realm
of the kernel, or even user policy.

	Arnd
