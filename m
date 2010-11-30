Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0K3TTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:19:25 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51356 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752480Ab0K3TTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:19:23 -0500
Date: Tue, 30 Nov 2010 20:19:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Edwards <grant.b.edwards@gmail.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20101130191913.GA5295@ucw.cz>
References: <i9kk4o$svc$1@dough.gmane.org>
 <4CC418A9.6090602@evidence.eu.com>
 <4CDA630F.4060903@atmel.com>
 <20101110172842.GC12371@suse.de>
 <4CDBC3EC.6020707@evidence.eu.com>
 <20101116143016.GB6527@ucw.cz>
 <AANLkTi=grehSnfWzCDtSXXmNb=-NAwbHHJ_P1XPyOuw8@mail.gmail.com>
 <20101116172013.102e06a6@lxorguk.ukuu.org.uk>
 <ibuh1v$uh6$1@dough.gmane.org>
 <20101116200426.75085b68@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116200426.75085b68@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-16 20:04:26, Alan Cox wrote:
> > Comtrol, Moxa, B&B, Sealevel, and others all sell PCI cards and
> > Ethernet attached serial ports that have selectable interfaces
> > (typically RS-232/422/485).  Comtrol and Moxa have had drivers in the
> > kernel tree for ages, but they've always had to use custom ioctl calls
> > for things like configuring 232/485/422 mode and half/full-duplex
> > mode.
> 
> Ok so what is needed that isn't covered by the current termiox and
> TIOCG/SRS485 ioctls ?

IIRC selection of 232/485/422 mode was missing from proposed api.

> > Having a standard API for things like interface mode, half-full
> > duplex, inter-character timeout, 9-bit mode, and so on would be life a
> > lot easier for those of us who maintain Linux serial drivers...
> 
> 9bit mode is a real problem with the tty layer defined in terms of 8bit
> streams but yes.

Well, if you wanted to have some fun... kontron card is able to
timestamp incoming characters, and saves state of the control signals
when character is received...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
