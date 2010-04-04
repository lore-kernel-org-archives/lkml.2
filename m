Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0DDS67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 14:58:59 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:33624 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0DDS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 14:58:53 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
	<201003310125.26266.laurent.pinchart@ideasonboard.com>
	<v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
	<20100401165606.GA1677@ucw.cz> <87aatn9k7j.fsf@old-tantale.fifi.org>
	<20100404132223.GA1346@ucw.cz>
From: Philippe Troin <phil@fifi.org>
Date: 04 Apr 2010 11:58:50 -0700
In-Reply-To: <20100404132223.GA1346@ucw.cz>
Message-ID: <87ljd3ujrp.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
> 
> > > > Do you mean the dmesg output ?
> > > > A full dmesg is included in this address :
> > > > http://pastebin.com/8XU619Uk
> > > > Not in all suspend/hibernate the problem comes, only in some of them
> > > > and this included dmesg output is just after a non working case of
> > > > webcam fault.
> > > > 
> > > > 
> > > > I also have found this in `/var/log/messages | grep uvcvideo`
> > > > Mar 31 00:31:16 linux-l365 kernel: [399905.714743] usbcore:
> > > > deregistering interface driver uvcvideo
> > > > Mar 31 00:31:24 linux-l365 kernel: [399914.121386] uvcvideo: Found UVC
> > > > 1.00 device LG Webcam (0c45:62c0)
> > > > Mar 31 00:31:24 linux-l365 kernel: [399914.135661] usbcore: registered
> > > > new interface driver uvcvideo
> > > 
> > > Also try unloading uvcvideo before suspend and reloading it after
> > > resume...
> > 
> > I have a similar problem with a Creative Optia webcam.
> > 
> > I have found that removing the ehci_hcd module and reinserting it
> > fixes the problem.
> > 
> > If your kernel ships with ehci_hcd built-in (F11 and later), the
> > script included also fixes the problem (it rebind the device).
> > 
> > Of course, I'd love to see this issue fixed.
> 
> If unload/reload of uvcvideo helps, it is most likely problem in that.
> 
> If unload/reload of ehci_hcd is needed, it is most likely ehci problem.

My testing shows that:

 1. If I remove uvcvideo BEFORE suspend and reinsert it after resume,
    it works.  However, I cannot always rmmod uvcvideo before suspend
    as it may be in use.

 2. As a work around, removing ehci_hcd and reinserting ehci_hcd upon
    resume works as well.

 3. Since my distribution's kernels come with ehci_hcd built into the
    kernel, and I cannot do #2 any more, I also found that unbinding
    and rebinding the device (with the script I sent earlier on) works
    as well.

I think uvcvideo is failing to reinitialize the camera on resume, and
forcing an uvcvideo "reset" with either of these three methods kicks
uvcvideo into working again.

Phil.
