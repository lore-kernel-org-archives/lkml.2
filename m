Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2BXQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:56:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38341 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2BXQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:56:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.243.144 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 08:54:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224165448.GA8751@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 11:38:54AM -0500, Jidong Xiao wrote:
> On Fri, Feb 24, 2012 at 10:38 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Feb 24, 2012 at 10:19:36AM -0500, Jidong Xiao wrote:
> >> On Wed, Feb 22, 2012 at 11:56 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > I am just curious. Since the concept user-space device drivers has
> >> > been proposed for several years, and some related projects and
> >> > research papers have demonstrated the feasibility of of moving device
> >> > drivers into use space. In particular, this paper:
> >> >
> >> > Tolerating Malicious Device Drivers in Linux.
> >> > http://pdos.csail.mit.edu/papers/sud:usenix10.pdf
> >> >
> >> > In this paper, existing device driver code need not to be changed,
> >> > which should help the idea to be applied in practice.

Please note, that one of the strengths of Linux is that we CAN change
driver code, and we do, which makes implementations like this nice from
an academic point of view, but unrealistic from a real-world point of
view.

> >> Actually, my major concern is, since UIO has been accepted, then why
> >> don't we move all the rest device drivers into user space as well. As
> >> I understand, currently, some of device drivers are running on user
> >> space, while the other (or say the majority of) device drivers are
> >> running on kernel space, so why don't we maintain a consistent device
> >> drivers infrastructure, say, either all in user space, or all in
> >> kernel space. (Sure some critical device drivers still need to be kept
> >> in kernel space.)
> >
> > Feel free to create patches to do so, and handle all of the userspace
> > changes needed in order to implement this.
> >
> > I think you haven't thought through the true reason we have device
> > drivers, and why Linux isn't a microkernel...
> >
> > And I'd take exception to your "advantage:" line above, I don't believe
> > that is true at all.
> >
> > Best of luck with your work,
> >
> Although I was asking "can we" do something, I am not actually
> strongly in favor of either move or not move, as indeed it costs too
> much to do the moving job.

Then why even discuss this at all?  What is your goal here?  If it is to
have others do work based on an idea you pointed out, you are in the
wrong place.

> But when you say "handle all of the userspace changes needed in order
> to implement this", if the device driver can be moved without
> modification (like the paper above shows), there should not be much
> changes required for user space applications.

The paper shows one such implementation that purports to not need
userspace changes.  As we have yet to see any code, I remain
unconvinced.

> Also, if user space device drivers is a bad idea, why drivers/uio has
> been created and merged into mainline kernel?

UIO fits a real need for some types of devices, why wouldn't it be
merged?  You are trying to say it is to be used for all drivers, which
is totally missing the point.

> Regarding "And I'd take exception to your "advantage:" line above, I
> don't believe that is true at all", do you agree that a significant
> portion of kernel crash incidents are due to bugs in drivers?

No I do not.  If you refer to the references from the paper where they
make that claim, they are talking about a different operating system
than Linux.  But, by virtue of the fact that the majority of the code
running in your kernel is drivers, yes, odds are drivers will have a
small majority of the bugs overall, given the percentages involved.
However, the bugs-per-line-of-code for Linux drivers is _much_ less than
other operating systems, especially given the fact that Linux drivers
require much less lines of code overall than other operating systems
(30% at the most for the majority of device types.)  So I would like to
see real numbers backing up your claim before I agree with it.

> As to "Linux isn't a microkernel", even though the debate between
> Linux and microkernel have never stopped,

Um, who is having such a debate?  We aren't, so I don't think the debate
has ever started.

> it's hard to deny the fact that Linux is slowly slowly moving towards
> a microkernel structure: LKM, fuse, uio, etc.

"LKM", what do you mean by that?

FUSE and UIO fit the needs of some specific devices / filesystems, that
is why Linux supports them.  To claim that their presence indicates that
Linux is becoming a microkernel is to show a lack of understanding what
a real microkernel is.

thanks,

greg k-h
