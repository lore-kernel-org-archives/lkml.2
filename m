Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1GFUsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:48:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1GFUsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:48:06 -0400
Date: Wed, 6 Jul 2011 13:46:47 -0700
From: Greg KH <gregkh@suse.de>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc6+ : khubd blocked (usbnet_cdc_unbind)
Message-ID: <20110706204647.GC1460@suse.de>
References: <Pine.LNX.4.44L0.1107061210070.1995-100000@iolanthe.rowland.org>
 <201107061844.25689.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201107061844.25689.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 06:44:25PM +0200, Arkadiusz Miskiewicz wrote:
> On Wednesday 06 of July 2011, Alan Stern wrote:
> > On Wed, 6 Jul 2011, Éric Piel wrote:
> > > Hello,
> > > It seems I'm very unlucky this week and I've come across to what looks
> > > like a second regression in the kernel. I'm running a version few
> > > commits after 3.0-rc6, which includes commit e534c5b831c8 "fix
> > > regression occurring during device removal".
> > > 
> > > When I plug/unplug/plug a mobile phone, after waiting a few minutes I
> > > get a "task khubd:621 blocked for more than 120 seconds." Note that it's
> > > directly connected to my laptop, not via an external hub (although the
> > > bug also happens with an external hub).
> > > 
> > > Below is the whole dmesg log (with usb debug messages on)
> > > 
> > > Let me know if you need me to investigate more, or maybe there is
> > > already a fix for that bug?
> > 
> > Ah -- this stack dump points out the reason for the hang.  It looks
> > like that "fix regression..." commit didn't go far enough; I neglected
> > the fact that interfaces can be unbound out of order when a driver
> > claims multiple interfaces.
> > 
> > Adding this patch on top of that commit should fix this.  Let me
> > know what you both get.
> 
> This one makes usb working after resume from ram (current Linus git + this 
> patch).

Thanks so much for testing.

Alan, care to resend this to me so I can get it to Linus?

greg k-h
