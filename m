Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2GSTED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:04:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751170Ab2GSTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:04:00 -0400
Date: Thu, 19 Jul 2012 15:03:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: USB enumeration post-resume NOT persistent yet "persist" -->
 swapped devices nodes --> root partition reference broken
In-Reply-To: <20120719173057.GA1031@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.44L0.1207191454140.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012, Andreas Mohr wrote:

> Hi,
> 
> On Thu, Jul 19, 2012 at 11:11:50AM -0400, Alan Stern wrote:
> > On Thu, 19 Jul 2012, Andreas Mohr wrote:
> > 
> > > Hi,
> > > 
> > > Yesterday I was surprised to see that with *another* external USB disk
> > > happening to be connected before boot,
> > > the system booted with root partition device sdb1 assigned rather than sda1.
> > > Not thinking much, I then proceeded putting the system into suspend,
> > 
> > Do you mean "suspend" or "hibernate"?
> 
> Doh - S2R. I don't do persistent hibernate here (writing some 1GB of data
> to flash-based storage each time possibly isn't all too healthy anyway).
> 
> > Can you reproduce the problem?
> 
> Will retry soonish.

It's understandable that you might not want to risk corrupting an
important filesystem.  Some systems allow you to run with a read-only
root and no swap; you could try that.  Or run entirely from within an
initramfs image, the way a Rescue CD does.

> > > http://lists.linux-foundation.org/pipermail/linux-pm/2009-November/023101.html
> > > Netbook Acer Aspire One A110L.
> > > Running 3.5.0-rc7+ here (yes ma'am, bleeding edge tester :).
> > > Was the first time to attempt resume with an additional device remaining
> > > connected, IIRC - that -rc7 thing likely doesn't play much of a role here.
> > > A bit hesitant to (dis-)prove the bug's "regression flag" with another version
> > > since random possibly succeeding I/O accesses to incompatible devices
> > > are not necessarily my thing (or is this safe to attempt again? Any more
> > > specific session info one would need?).
> > 
> > Well, the dmesg log would help.  If you still think the USB layer is at 
> > fault then you should enable CONFIG_USB_DEBUG.
> 
> Maybe I can get this successfully off the machine next time,
> by pre-caching required binaries prior to initiating a non-working resume.

Running within an initramfs image would probably avoid this problem.

> > > So, again, possibly USB persistence is bug-broken?
> > 
> > You don't have any good evidence to suggest that.  None of the
> > information you provided indicates that any USB device nodes (such as
> > /dev/bus/usb/001/002) got mixed up.  All you know is that the
> > block-layer device nodes (such as /dev/sda2) got changed.
> 
> OK - so you're trying in vain to tell dense me that I'm supposed to
> take note of the *non-changing* (i.e., correctly "persistent")
> USB device ID scheme rather than the roguely changing device nodes.
> To which I say that unfortunately I don't have a pre/post comparison
> at this moment yet.

That's one of the reasons why reproducing the problem is important.

> > Furthermore, if USB persist were broken then the symptoms would be 
> > different.  Instead of starting with a root partition at sdb1 and then 
> > finding it at sda1, you would have found it gone completely and there 
> > would be _new_ devices labelled sdc and sdd.
> 
> Ah, yeah - I tend to know *this* other effect, too...

Not recently, I hope!

> > Alan Stern
> 
> Thanks a ton for your reply!
> Now I know that there's a tendency to better look on the other side
> (block device layer etc.) and analyze things there,
> once it's established that USB topology ID numbering in fact did persist.

What you described does sound very weird.  The relation between block 
devices and the underlying physical devices is determined entirely by 
software data structures, which should not change over the course of a 
suspend.  I don't understand how it could have happened.

Alan Stern

