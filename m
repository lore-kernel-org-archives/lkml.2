Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1DRVnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:43:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1DRVnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:43:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 9/14] PM / Blackfin: Use struct syscore_ops instead of sysdevs for PM
Date: Mon, 18 Apr 2011 23:43:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Ralf Baechle <ralf@linux-mips.org>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172311.59289.rjw@sisk.pl> <BANLkTi=BRXtsG0wK6SbK-6L-xzwMccR3eQ@mail.gmail.com>
In-Reply-To: <BANLkTi=BRXtsG0wK6SbK-6L-xzwMccR3eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104182343.41702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 18, 2011, Mike Frysinger wrote:
> On Sun, Apr 17, 2011 at 17:11, Rafael J. Wysocki wrote:
> > Convert some Blackfin architecture's code to using struct syscore_ops
> > objects for power management instead of sysdev classes and sysdevs.
> >
> > This simplifies the code and reduces the kernel's memory footprint.
> > It also is necessary for removing sysdevs from the kernel entirely in
> > the future.
> 
> looks straight forward enough ...
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> 
> > +static struct syscore_ops nmi_syscore_ops = {
> >        .resume         = nmi_wdt_resume,
> >        .suspend        = nmi_wdt_suspend,
> >  };
> 
> a bit sad this couldnt be made const

Well, that would trigger a compiler warning from register_syscore_ops().

However, I'm going to make that change change everywhere at once when all of
the conversions have been made, since it looks like we're only going to have
static syscore_ops.

Thanks,
Rafael
