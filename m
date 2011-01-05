Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1AEWnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:43:43 -0500
Received: from kroah.org ([198.145.64.141]:59915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1AEWnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:43:41 -0500
Date: Wed, 5 Jan 2011 14:42:21 -0800
From: Greg KH <greg@kroah.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Tsozik <tsozik@yahoo.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and
 _get_icount functions
Message-ID: <20110105224221.GA18452@kroah.com>
References: <20101227151237.744bbb6e@lembas.zaitcev.lan>
 <711019.98747.qm@web65713.mail.ac4.yahoo.com>
 <20101227234047.3f70a515@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227234047.3f70a515@lembas.zaitcev.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 11:40:47PM -0700, Pete Zaitcev wrote:
> On Mon, 27 Dec 2010 20:04:51 -0800 (PST)
> Tsozik <tsozik@yahoo.com> wrote:
> 
> > So I ran geiger counter against /dev/ttyS0 device for 20 minutes and
> > acquired 20 measurements. Then I compared last average with last 20
> > minute measurement average acquired via mct_u232 on the laptop placed
> > nearby. The error was ~4% (rounded up).
> 
> Great, I'm ready to ack.
> 
> There's just one thing that is bugging me... I think it would be best
> if Alan Cox or Greg Kroah commented on it. The edgeport does the
> following, which we copied:
> 
> 
> 		schedule();
> 		........
> 		if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
> 		    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
> 			return -EIO; /* no change => error */
> 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
> 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
> 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
> 		    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
> 			return 0;
> 		}
> 
> So, if there was a status report, but no change to bits, the ioctl
> TIOCMIWAIT would return with -EIO. In serial_core.c, that serves
> conventional non-USB UARTs, nothing like this occurs. I am not quite
> sure what the point of doing this -EIO check is.

Odd, I don't really remember where I copied that logic from, that was a
long time ago.

> Oh and BTW, I'm wondering what is going to happen if the device is
> disconnected while an application is blocked waiting for the status
> change. The patch is not particularly bad here, it just copies
> an existing code from elsewhere.

It should handle the disconnect, if not, we should fix it.

thanks,

greg k-h
