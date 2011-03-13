Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1CMQ22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:28:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45215 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1CMQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:28:27 -0400
Date: Sun, 13 Mar 2011 16:28:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Nikolai Kondrashov <spbnick@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110313162812.GA25369@srcf.ucam.org>
References: <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com> <4D7C9668.3000902@gmail.com> <20110313161752.GC10718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110313161752.GC10718@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 09:17:53AM -0700, Greg KH wrote:
> On Sun, Mar 13, 2011 at 12:03:20PM +0200, Nikolai Kondrashov wrote:
> > Sometime ago I've found this hack on some forum, which I use currently
> > to set the brightness:
> > 
> > setpci -s 00:02.0 f4.b="$HEX_BYTE"
> > 
> > It allows finer control of the brightness, but it seems it operates directly
> > on the video card PCI register. I assume there is no sane way to use
> > this interface from the platform driver, right?
> 
> Yes, do not do this, it causes all sorts of problems in the end, not the
> least being the BIOS doesn't know what is going on at all as you are
> changing the brightness without it knowing it.

It's also modifying configuration that belongs to a device being managed 
by another driver, so it's the kind of thing we frown upon. Having said 
that, the Intel driver should gain native backlight support in .39.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
