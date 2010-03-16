Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0CPVY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:24:26 -0400
Received: from kroah.org ([198.145.64.141]:49024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0CPVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:24:22 -0400
Date: Tue, 16 Mar 2010 14:23:37 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] tty_port,usb-console: Fix usb serial console
	open/close regression
Message-ID: <20100316212337.GB31739@kroah.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com> <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 04:05:42PM -0500, Jason Wessel wrote:
> Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
> shutdown() operation") breaks the ability to use a usb console
> starting in 2.6.33.  This was observed when using
> console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
> error is:
> 
> ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22
> 
> The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
> tty_port_shutdown() it always clears the flag if it is set.  The fix
> is to add a variable to the tty_port struct to indicate when the tty
> port is a console.

I've already applied this to my trees, right?


thanks,

greg k-h
