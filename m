Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0DKPoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 11:44:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46322 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143Ab0DKPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 11:44:44 -0400
Date: Sun, 11 Apr 2010 17:44:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Philippe Troin <phil@fifi.org>,
       Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
Message-ID: <20100411154437.GA16098@elf.ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
 <87ljd3ujrp.fsf@old-tantale.fifi.org>
 <20100404193405.GA15065@elf.ucw.cz>
 <201004111253.58237.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004111253.58237.laurent.pinchart@ideasonboard.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > My testing shows that:
> > >  1. If I remove uvcvideo BEFORE suspend and reinsert it after resume,
> > >  
> > >     it works.  However, I cannot always rmmod uvcvideo before suspend
> > >     as it may be in use.
...
> > > I think uvcvideo is failing to reinitialize the camera on resume, and
> > > forcing an uvcvideo "reset" with either of these three methods kicks
> > > uvcvideo into working again.
> > 
> > Ok, that puts the problem firmly into uvcvideo area.
> 
> No, it doesn't.

I believe that the fact that rmmod/insmod fixes it means that problem
is in the driver (and not in ehci or something like that).

> First of all, the dmesg output available on pastebin.com is difficult to 
> understand. As it seems you perform several suspend/resume cycles there. 
> Mohamed, could you please
> 
> - clear the kernel log ('dmesg -c' as root)
> - suspend and resume your system
> - post the kernel log content ('dmesg')
> - clear the kernel log
> - try to use your webcam with whatever test software your prefer
> - describe the failure (application error messages, ...)
> - post the kernel log content

Good idea.

> > Try changing its _resume routine to whatever is done on device
> > unplug... it should be rather easy, and is quite close to "correct"
> > solution.
> 
> That's not a solution. Devices are supposed to resume properly without being 
> reset. The camera might be crashing, or the USB core might be doing something 
> wrong, requiring some kind of reset. I'd like to diagnose the problem 
> correctly before trying to fix it.

Ok. (You are right that simulating rmmod/insmod is not the same as
proper suspend/resume support, but I still guess it would help with
debugging.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
