Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2HQOnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:43:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab2HQOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:43:04 -0400
Date: Fri, 17 Aug 2012 07:42:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817144253.GA12835@kroah.com>
References: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
 <Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:38:16AM -0400, Alan Stern wrote:
> On Fri, 17 Aug 2012, Ming Lei wrote:
> 
> > But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
> > further after kernel init is completed?  Or even devices should be allowed
> > to add into system?
> 
> Indeed, does it make any sense to have USB support at all if HOTPLUG
> isn't enabled?  Should USB select HOTPLUG?

Well, a long time ago people wanted to use USB but not have HOTPLUG
enabled in their systems for various (odd) embedded systems.  As it's
pretty hard to even turn off HOTPLUG these days, I'd be more likely to
just remove CONFIG_HOTPLUG entirely given the dynamic nature of almost
all systems.

So no, I don't think we should select HOTPLUG for USB.

greg k-h
