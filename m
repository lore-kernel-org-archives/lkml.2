Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799Ab0J2TvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:51:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:42538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0J2TvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:51:11 -0400
Date: Fri, 29 Oct 2010 12:50:39 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: samu.p.onkalo@nokia.com, alan@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: sysfs and power management
Message-ID: <20101029195039.GA26401@suse.de>
References: <1288177143.12206.22.camel@4fid08082>
 <20101027124816.7087436a@linux.intel.com>
 <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
 <20101027152809.39701917@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027152809.39701917@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:28:09PM +0100, Alan Cox wrote:
> > Do you mean per device hook and each sysfs open / close uses 
> > per device ref-counting.
> 
> Or you can do it by having an optional per device hook which is passed
> the sysfs node for each open/close and leave the rest up to the driver.
> If it needs to do clever stuff it can.

I really don't want to add open/close to the sysfs file model for the
driver core.

What is the specific problem with not doing any sensor work until
userspace asks for the data?  Then do the read from the hardware and go
back to sleep.  That's probably the best way to do this, as userspace
isn't going to open the sysfs file and not close it instantly anyway
after it has read the data (seeking on a sysfs file isn't really
recommended, even if it sometimes seems to work.)

thanks,

greg k-h
