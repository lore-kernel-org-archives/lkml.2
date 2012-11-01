Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243Ab2KAOt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:49:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55352 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2KAOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:49:25 -0400
Date: Thu, 1 Nov 2012 14:49:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101144912.GA10269@srcf.ucam.org>
References: <2548314.3caaFsMVg6@linux-lqwf.site>
 <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 02:42:15PM +0000, James Bottomley wrote:
> On Thu, 2012-11-01 at 10:29 -0400, Eric Paris wrote:
> > Imagine you run windows and you've never heard of Linux.  You like
> > that only windows kernels can boot on your box and not those mean
> > nasty hacked up malware kernels.  Now some attacker manages to take
> > over your box because you clicked on that executable for young models
> > in skimpy bathing suits.  That executable rewrote your bootloader to
> > launch a very small carefully crafted Linux environment.  This
> > environment does nothing but launch a perfectly valid signed Linux
> > kernel, which gets a Windows environment all ready to launch after
> > resume and goes to sleep.  Now you have to hit the power button twice
> > every time you turn on your computer, weird, but Windows comes up, and
> > secureboot is still on, so you must be safe!
> 
> So you're going back to the root exploit problem?  I thought that was
> debunked a few emails ago in the thread?

The entire point of this feature is that it's no longer possible to turn 
a privileged user exploit into a full system exploit. Gaining admin 
access on Windows 8 doesn't permit you to install a persistent backdoor, 
unless there's some way to circumvent that. Which there is, if you can 
drop a small Linux distribution onto the ESP and use a signed, trusted 
bootloader to boot a signed, trusted kernel that then resumes from an 
unsigned, untrusted hibernate image. So we have to ensure that that's 
impossible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
