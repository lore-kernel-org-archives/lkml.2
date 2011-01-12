Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1ALMn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:43:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39067 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1ALMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:43:57 -0500
Date: Wed, 12 Jan 2011 12:43:54 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Jamie Iles <jamie@jamieiles.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH] watchdog: Add driver for Altera Watchdog Timer
Message-ID: <20110112124353.GE2658@pulham.picochip.com>
References: <1294829027-15029-1-git-send-email-tklauser@distanz.ch>
 <20110112114800.GB2658@pulham.picochip.com>
 <20110112123637.GT29757@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112123637.GT29757@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:36:37PM +0100, Tobias Klauser wrote:
[...]
> > > +static long altera_wdt_ioctl(struct file *file, unsigned int cmd,
> > > +		unsigned long arg)
> > > +{
> > > +	struct altera_wdt_dev *wdev = file->private_data;
> > > +	void __user *argp = (void __user *) arg;
> > > +
> > > +	switch (cmd) {
> > > +	case WDIOC_GETSUPPORT:
> > > +		return copy_to_user(argp, &altera_wdt_info, sizeof(altera_wdt_info));
> > > +	case WDIOC_KEEPALIVE:
> > > +		altera_wdt_ping(wdev);
> > > +		return 0;
> > > +	default:
> > > +		return -ENOTTY;
> > > +	}
> > > +}
> > 
> > Can you set/get the timeout period on this watchdog?  Even if you can't 
> > set it then it would be good to allow the user to read the constant 
> > timeout that the watchdog uses so it knows how often to kick it.  If you 
> > use the software timeout heartbeat then in the future you could emulate 
> > longer timeouts.
> 
> This is a very primitive watchdog timer which does only allow the
> timeout period to be set when instantiating the timer in the FPGA, so
> from a software point-of-view the timer has a fixed timeout. It doesn't
> even allow to read the timeout value directly from the "hardware".
> 
> But we could use the additional information (including the timeout value
> among a lot of other configurable values) generated when building the
> FPGA firmware and store that in the device tree (support for device tree
> was recently added to the Nios2 Linux port). So we could get it (and
> the base address) from there in the altera_wdt driver. Does that sound
> reasonable?

That sounds like a very good idea to me.  I can see that allowing 
userspace to know the timeout period would be useful.

Jamie
