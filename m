Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0DDTdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 15:33:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751083Ab0DDTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 15:33:38 -0400
Date: Sun, 4 Apr 2010 21:34:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Philippe Troin <phil@fifi.org>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
Message-ID: <20100404193405.GA15065@elf.ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
 <201003310125.26266.laurent.pinchart@ideasonboard.com>
 <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
 <20100401165606.GA1677@ucw.cz>
 <87aatn9k7j.fsf@old-tantale.fifi.org>
 <20100404132223.GA1346@ucw.cz>
 <87ljd3ujrp.fsf@old-tantale.fifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljd3ujrp.fsf@old-tantale.fifi.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If unload/reload of uvcvideo helps, it is most likely problem in that.
> > 
> > If unload/reload of ehci_hcd is needed, it is most likely ehci problem.
> 
> My testing shows that:
> 
>  1. If I remove uvcvideo BEFORE suspend and reinsert it after resume,
>     it works.  However, I cannot always rmmod uvcvideo before suspend
>     as it may be in use.
> 
>  2. As a work around, removing ehci_hcd and reinserting ehci_hcd upon
>     resume works as well.
> 
>  3. Since my distribution's kernels come with ehci_hcd built into the
>     kernel, and I cannot do #2 any more, I also found that unbinding
>     and rebinding the device (with the script I sent earlier on) works
>     as well.
> 
> I think uvcvideo is failing to reinitialize the camera on resume, and
> forcing an uvcvideo "reset" with either of these three methods kicks
> uvcvideo into working again.

Ok, that puts the problem firmly into uvcvideo area.

Try changing its _resume routine to whatever is done on device
unplug... it should be rather easy, and is quite close to "correct"
solution.


									Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
