Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2BXPpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:45:38 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42752 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab2BXPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:45:37 -0500
X-Sasl-enc: 0+2bO/ZvWLxBhBrbrc/AslpmsmCQ1clSu/7E/DZWTX3L 1330098336
Date: Fri, 24 Feb 2012 07:38:11 -0800
From: Greg KH <greg@kroah.com>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224153811.GA16535@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:19:36AM -0500, Jidong Xiao wrote:
> On Wed, Feb 22, 2012 at 11:56 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> > Hi,
> >
> > I am just curious. Since the concept user-space device drivers has
> > been proposed for several years, and some related projects and
> > research papers have demonstrated the feasibility of of moving device
> > drivers into use space. In particular, this paper:
> >
> > Tolerating Malicious Device Drivers in Linux.
> > http://pdos.csail.mit.edu/papers/sud:usenix10.pdf
> >
> > In this paper, existing device driver code need not to be changed,
> > which should help the idea to be applied in practice.
> >
> > The advantage and disadvantage of move device drivers into use space
> > of both obvious:
> >
> > Advantage: Since most of kernel bugs are caused by device drivers
> > issues, moving device drivers into user space can reduce the impact of
> > device driver bugs. From security perspective, the system can be more
> > secure and robust if most device drivers are working in user space.
> > Disadvantage: At least, existing techniques as well as the above paper
> > showed a relatively high overhead.
> >
> > So is it mainly because the high overhead that prevents the user-space
> > device drivers ideas being accepted in Linux?
> >
> 
> Actually, my major concern is, since UIO has been accepted, then why
> don't we move all the rest device drivers into user space as well. As
> I understand, currently, some of device drivers are running on user
> space, while the other (or say the majority of) device drivers are
> running on kernel space, so why don't we maintain a consistent device
> drivers infrastructure, say, either all in user space, or all in
> kernel space. (Sure some critical device drivers still need to be kept
> in kernel space.)

Feel free to create patches to do so, and handle all of the userspace
changes needed in order to implement this.

I think you haven't thought through the true reason we have device
drivers, and why Linux isn't a microkernel...

And I'd take exception to your "advantage:" line above, I don't believe
that is true at all.

Best of luck with your work,

greg k-h
