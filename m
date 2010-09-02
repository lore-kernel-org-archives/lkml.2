Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0IBUMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:12:07 -0400
Received: from kroah.org ([198.145.64.141]:57318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab0IBULt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:11:49 -0400
Date: Thu, 2 Sep 2010 13:08:39 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Hank Janssen <hjanssen@sailtheuniverse.com>, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets - RESEND
Message-ID: <20100902200839.GD16897@kroah.com>
References: <4C7D4848.6090409@sailtheuniverse.com>
 <1283358535.1797.174.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283358535.1797.174.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 09:28:53AM -0700, Joe Perches wrote:
> On Tue, 2010-08-31 at 11:22 -0700, Hank Janssen wrote:
> > If we get a SCSI host bus reset we now gracefully handle it, and we 
> > take the device offline. This before sometimes caused hangs.
> > ---
> >  drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
> []
> > +	/*
> > +	 * Wait for traffic in transit to complete
> > +	 */
> > +	while (atomic_read(&storDevice->NumOutstandingRequests))
> > +		udelay(1000);
> > +
> 
> Is it useful to have a maximum check or timeout?
> Maybe use usleep_range?

Yeah, that's not good, you need to have some way to get out of here in
case something bad happens and that number never goes down.

Why not just use a completion function instead of a busy loop?

thanks,

greg k-h
