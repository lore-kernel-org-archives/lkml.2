Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949Ab2FVBsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:48:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2FVBsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:48:30 -0400
Date: Thu, 21 Jun 2012 18:48:25 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alexis Cortes <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622014825.GB3318@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <20120621003232.GD3255@kroah.com>
 <003001cd4fd3$a7648950$f62d9bf0$@cortes@ti.com>
 <20120622000858.GB629@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622000858.GB629@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 05:08:58PM -0700, Sarah Sharp wrote:
> On Thu, Jun 21, 2012 at 12:31:12PM -0500, Alexis Cortes wrote:
> > Hi Greg,
> > 
> > I understand your concerns, however as I mentioned before, any xHCI host
> > that has this particular re-driver between its root-ports and the physical
> > ports of the system will be subject to suffer of this compliance mode issue
> > (once the port has entered compliance mode, it becomes unusable so no device
> > that is plugged to that port will work until a warm reset is applied to it).
> > For a system that has this re-driver, this problem could hit about 20%-40%
> > of the times (however this percentage is subject to the quality of the
> > internal connection) and unfortunately there is no way to programmatically
> > detect if this re-driver is on the system.
> > 
> > As Sarah proposed, we certainly can apply this patch as a module parameter
> > disabled by default and let know our clients that we know are using this
> > re-driver to enable the feature to avoid the issue.
> 
> I don't think that would work very well.  Are those clients supposed to
> notify Linux OSVs when a system will ship with that redriver so they can
> turn it on for Linux preloads of those systems?  What about the average
> Linux user who installs Linux themselves?
> 
> An alternative approach, since you know which clients are using the
> re-driver, is to just add a quirk, and get them to tell us when they're
> shipping a system with your redriver.  Then we can turn it on in the
> mainline kernel, all Linux distros will pick it up, and we will avoid
> disgruntled users.
> 
> Or we can just modify the timer to a more reasonable value like 10
> seconds, and users will just have to put up with the longer enumeration
> times.
> 
> Greg, what about exporting a sysfs file to change the polling interval?
> We could run the timer every 2 seconds by default, but get powertop to
> add a new setting for turning the interval off.

Ick, a sysfs file is almost as bad as a kernel module option, how are
you going to tell users / distros when to turn it off or not if you
don't know if it is needed or not?

We really need a way to determine the hardware here.

Alexis, what are you doing on Windows for this?  Surely you can't be
turning a timer on every 2 seconds for all Windows systems in the world,
are you?

thanks,

greg k-h
