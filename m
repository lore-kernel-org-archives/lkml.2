Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1GHSLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:11:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1GHSK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:10:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/7] ARM / Samsung: Use struct syscore_ops for "core" power management
Date: Fri, 8 Jul 2011 20:12:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-omap@vger.kernel.org
References: <201103280125.11750.rjw@sisk.pl> <201103280129.50192.rjw@sisk.pl> <20110327234521.GH9995@trinity.fluff.org>
In-Reply-To: <20110327234521.GH9995@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107082012.07610.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 28, 2011, Ben Dooks wrote:
> On Mon, Mar 28, 2011 at 01:29:49AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Replace sysdev classes and struct sys_device objects used for "core"
> > power management by Samsung platforms with struct syscore_ops objects
> > that are simpler.
> > 
> > This generally reduces the code size and the kernel memory footprint.
> > It also is necessary for removing sysdevs entirely from the kernel in
> > the future.
> 
> Hmm, does it still allow the system to choose which bits are bound
> depending on the cpu being registered, as for the s3c stuff it isn't
> just about the suspend/resume, it's binding items that get registered
> early in the startup sequence?

Yes, it does, AFAICS.  It didn't change the bits that weren't directly
related to suspend/resume (at least that wasn't the intention).

That said, using sysdevs for the initialization of things the way you describe
will have to change anyway, because sysdevs are going to be removed entirely
from the kernel at one point.

Thanks,
Rafael
