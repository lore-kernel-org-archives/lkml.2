Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab1E0A3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:29:33 -0400
Received: from infernal.debian.net ([87.230.26.131]:49449 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1E0A3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:29:32 -0400
Date: Fri, 27 May 2011 02:29:29 +0200
From: Andreas Bombe <aeb@debian.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Message-ID: <20110527002928.GA4369@amos.fritz.box>
References: <20110525235920.GA5279@amos.fritz.box>
 <20110526071104.GE29833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526071104.GE29833@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:11:04AM -0700, Greg KH wrote:
> On Thu, May 26, 2011 at 01:59:22AM +0200, Andreas Bombe wrote:
> > A minimalist way to trigger this issue is with a serial port that has
> > nothing attached:
> > 
> > stty -F /dev/ttyS0 crtscts
> > echo >/dev/ttyS0
> > 
> > The echo triggers a 30 second timeout on close while the driver is
> > trying to flush the newline. Another way is developing an USB device
> > with a virtual serial port and having it stop (by debugger or
> > crash/lockup)...
> > 
> > Any ideas on how to progress?
> 
> Can you try Linus's tree right now?  A number of changes went in during
> this merge window that might help out here I think.

I think I had those changes already in the last try (Wednesday's git)
but I tried again with the very latest. No noticeable change.

-- 
Andreas Bombe
