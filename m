Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473Ab2FVQo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:44:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:44951 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab2FVQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183761719"
Date: Fri, 22 Jun 2012 09:44:23 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: Alexis Cortes <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622164423.GD629@xanatos>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <20120621003232.GD3255@kroah.com>
 <003001cd4fd3$a7648950$f62d9bf0$@cortes@ti.com>
 <20120622000858.GB629@xanatos>
 <20120622014825.GB3318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622014825.GB3318@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 06:48:25PM -0700, 'Greg KH' wrote:
> On Thu, Jun 21, 2012 at 05:08:58PM -0700, Sarah Sharp wrote:
> > Greg, what about exporting a sysfs file to change the polling interval?
> > We could run the timer every 2 seconds by default, but get powertop to
> > add a new setting for turning the interval off.
> 
> Ick, a sysfs file is almost as bad as a kernel module option, how are
> you going to tell users / distros when to turn it off or not if you
> don't know if it is needed or not?

The same way users discover whether their USB devices break if
auto-suspend is turned on.  They go into powertop, and change the line
for their USB device from "BAD" to "GOOD".  Then they notice their mouse
suddenly stops responding to movement, and they change the powertop
settings back.

In the same way, there would be a line like "Stop xHCI port polling
timer" that they would toggle.  Later, if devices under the ports
stopped enumerating, they would change it back to "BAD" and just put up
with the polling.

I agree it's not a very good system, and adding a quirk to the xHCI
driver is a better solution.  Ideally, TI would just fix their redriver.

> We really need a way to determine the hardware here.
> 
> Alexis, what are you doing on Windows for this?  Surely you can't be
> turning a timer on every 2 seconds for all Windows systems in the world,
> are you?

Yes, what are you going to do for Windows 8 systems that have official
Microsoft USB 3.0 support?  Make your customers ship a driver with the
polling turned on?

Sarah Sharp
