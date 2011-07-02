Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1GBCDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 22:03:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42607 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967Ab1GBCDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 22:03:32 -0400
Date: Fri, 1 Jul 2011 22:03:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <axboe@kernel.dk>, <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
In-Reply-To: <1309554818.2722.48.camel@mulgrave>
Message-ID: <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, James Bottomley wrote:

> On Fri, 2011-07-01 at 17:04 -0400, Alan Stern wrote:
> > On Fri, 1 Jul 2011, James Bottomley wrote:
> > 
> > > On Fri, 2011-07-01 at 14:14 -0400, Dave Jones wrote:
> > > > On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> > > > 
> > > >  > I found I can reliably crash a 3.0 system by pulling the
> > > >  > USB cable of a mounted USB cdrom (or rather a USB device which
> > > >  > has a builtin fake CD-ROM) 
> > > >  > 
> > > >  > I suspect it's a regression too.
> > > > 
> > > > We've been seeing a lot of similar bugs in Fedora since we pushed
> > > > a 2.6.38.8 update.  Some of the traces are different, but some
> > > > look to be the same as yours. (here's one for eg: https://bugzilla.redhat.com/show_bug.cgi?id=712830)
> > > > 
> > > > The common cause seems to be 'device went away'. So USB CD drives,
> > > > USB memory sticks, and for some reason virtualbox shutdown.
> > > 
> > > I think it's something specific in the USB path.  I can't reproduce on
> > > 3.0-rc5 with a SATA DVD hot unplug.  USB cc's added.
> > 
> > I just took a look at the Red Hat bugzilla entry mentioned above.  It 
> > seems to be quite different from the issue addressed by the patch I 
> > just posted -- a crash with invalid memory access rather than a lockdep 
> > violation and hang of the khubd thread.
> > 
> > It's also notable that the stack dump in the bugzilla report doesn't 
> > contain any functions in the USB subsystem.  Of course this doesn't 
> > prove anything, but it is suggestive.
> > 
> > Evidently the sdev argument to scsi_prep_state_check() was NULL.  This
> > looks like the problem that cropped up before, where q->queuedata was
> > getting set to NULL while the queue was still in use.  I can't imagine
> > how anything in usb-storage could have caused that.
> 
> Right ... the device release function has already been called, so it's
> some type of refcounting cockup.  The fact that I can't reproduce with a
> SATA unplug is what makes me think it might be USB specific ... of
> course, that's not definitive.

I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
give the exact sequence of steps you went through to trigger the bug?

Alan Stern

