Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1LFWCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:02:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1LFWCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:02:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver core: leave runtime PM enabled during system shutdown
Date: Tue, 6 Dec 2011 23:05:34 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>,
        Ming Lei <tom.leiming@gmail.com>,
        "Chen Peter-B29397" <B29397@freescale.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
References: <201112052332.10822.rjw@sisk.pl> <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org> <20111206214847.GH1247@kroah.com>
In-Reply-To: <20111206214847.GH1247@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112062305.34571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 06, 2011, Greg KH wrote:
> On Tue, Dec 06, 2011 at 10:26:14AM -0500, Alan Stern wrote:
> > Disabling all runtime PM during system shutdown turns out not to be a
> > good idea, because some devices may need to be woken up from a
> > low-power state at that time.
> > 
> > The whole point of disabling runtime PM for system shutdown was to
> > prevent untimely runtime-suspend method calls.  This patch (as1504)
> > accomplishes the same result by incrementing the usage count for each
> > device and waiting for ongoing runtime-PM callbacks to finish.  This
> > is what we already do during system suspend and hibernation, which
> > makes sense since the shutdown method is pretty much a legacy analog
> > of the pm->poweroff method.
> > 
> > This fixes a regression on some OMAP systems.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Reported-by: NeilBrown <neilb@suse.de>
> > CC: Chen Peter-B29397 <B29397@freescale.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Rafael, you will take this in your tree, right?

Yes, I will, thanks!
