Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab1DZVQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:16:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:43739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab1DZVQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:16:00 -0400
Date: Tue, 26 Apr 2011 13:59:50 -0700
From: Greg KH <gregkh@suse.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Tanya Brokhman <tlinder@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, balbi@ti.com,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110426205950.GD20381@suse.de>
References: <20110426172559.GA5405@xanatos>
 <Pine.LNX.4.44L0.1104261423250.2035-100000@iolanthe.rowland.org>
 <20110426200625.GB5405@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426200625.GB5405@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 01:06:25PM -0700, Sarah Sharp wrote:
> > One can always unbind usb-storage from an interface and bind uas to
> > that interface by hand, using sysfs.  At the moment there doesn't 
> > appear to be any mechanism for doing this automatically.  For example, 
> > usb-storage _could_ choose not to bind to an interface if there's a UAS 
> > altsetting -- but currently it doesn't take that into account.
> 
> How would the usb-storage driver reject a bind by the USB core?  By
> returning an error from the probe function?

Yes.

> Would the USB core go and search for the next driver after the BOT
> driver rejected the bind?

Yes.

> It looks like usb_probe_interface will just return an error if the
> first driver's probe function fails.

The driver core continues on and will probe the remaining drivers for
that bus.  Also, when a new driver shows up, the driver core asks if any
of the unbound devices should be bound to this new driver.

So you should be fine.

thanks,

greg k-h
