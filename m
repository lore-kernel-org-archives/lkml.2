Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab0DKKw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 06:52:57 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:48241 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0DKKw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 06:52:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: webcam problem after suspend/hibernate
Date: Sun, 11 Apr 2010 12:53:57 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33; KDE/4.4.2; x86_64; ; )
Cc: Philippe Troin <phil@fifi.org>,
       Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com> <87ljd3ujrp.fsf@old-tantale.fifi.org> <20100404193405.GA15065@elf.ucw.cz>
In-Reply-To: <20100404193405.GA15065@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004111253.58237.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 April 2010 21:34:06 Pavel Machek wrote:
> Hi!
> 
> > > If unload/reload of uvcvideo helps, it is most likely problem in that.
> > > 
> > > If unload/reload of ehci_hcd is needed, it is most likely ehci problem.
> > 
> > My testing shows that:
> >  1. If I remove uvcvideo BEFORE suspend and reinsert it after resume,
> >  
> >     it works.  However, I cannot always rmmod uvcvideo before suspend
> >     as it may be in use.
> >  
> >  2. As a work around, removing ehci_hcd and reinserting ehci_hcd upon
> >  
> >     resume works as well.
> >  
> >  3. Since my distribution's kernels come with ehci_hcd built into the
> >  
> >     kernel, and I cannot do #2 any more, I also found that unbinding
> >     and rebinding the device (with the script I sent earlier on) works
> >     as well.
> > 
> > I think uvcvideo is failing to reinitialize the camera on resume, and
> > forcing an uvcvideo "reset" with either of these three methods kicks
> > uvcvideo into working again.
> 
> Ok, that puts the problem firmly into uvcvideo area.

No, it doesn't.

First of all, the dmesg output available on pastebin.com is difficult to 
understand. As it seems you perform several suspend/resume cycles there. 
Mohamed, could you please

- clear the kernel log ('dmesg -c' as root)
- suspend and resume your system
- post the kernel log content ('dmesg')
- clear the kernel log
- try to use your webcam with whatever test software your prefer
- describe the failure (application error messages, ...)
- post the kernel log content

> Try changing its _resume routine to whatever is done on device
> unplug... it should be rather easy, and is quite close to "correct"
> solution.

That's not a solution. Devices are supposed to resume properly without being 
reset. The camera might be crashing, or the USB core might be doing something 
wrong, requiring some kind of reset. I'd like to diagnose the problem 
correctly before trying to fix it.

-- 
Regards,

Laurent Pinchart
