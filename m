Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1EZHO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:14:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45320 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab1EZHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:14:25 -0400
X-Sasl-enc: 4aH7DPFXk+AQDRnkFKn6XE0nDQABMWDe14vHgsU/vzMo 1306394063
Date: Thu, 26 May 2011 00:11:04 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Message-ID: <20110526071104.GE29833@kroah.com>
References: <20110525235920.GA5279@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525235920.GA5279@amos.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 01:59:22AM +0200, Andreas Bombe wrote:
> Short reminder/summary: Unlike the BKL, the tty_lock mechanism that
> replaced it does not release the lock while sleeping. This causes the
> tty_lock to be held for extended periods of time when uart_close()
> (running with tty_lock held) tries to flush the transmit buffer but is
> unable to do so.
> 
> The result is that until the transmit flush completes by the remote end
> finally accepting the data or the driver timing out and giving up,
> pretty much all tty operations freeze. No programs can be started
> and for some reason X freezes for me. From a user viewpoint, the
> computer effectively locks up for that time.
> 
> After I tracked the issue down to the tty_lock mechanism, I found some
> discussion on LKML about that from last November (thread starting here:
> http://lkml.kernel.org/r/4CCBCD8E.1020601@billauer.co.il ). However
> nothing has come of it, it appears, at least not in the official kernel.
> 
> A minimalist way to trigger this issue is with a serial port that has
> nothing attached:
> 
> stty -F /dev/ttyS0 crtscts
> echo >/dev/ttyS0
> 
> The echo triggers a 30 second timeout on close while the driver is
> trying to flush the newline. Another way is developing an USB device
> with a virtual serial port and having it stop (by debugger or
> crash/lockup)...
> 
> Any ideas on how to progress?

Can you try Linus's tree right now?  A number of changes went in during
this merge window that might help out here I think.

thanks,

greg k-h
