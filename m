Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2BXRIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:08:45 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38406 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2BXRIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:08:44 -0500
Message-ID: <1330103229.23014.130.camel@groeck-laptop>
Subject: Re: Can we move device drivers into user-space?
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Greg KH <greg@kroah.com>
CC: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 09:07:09 -0800
In-Reply-To: <20120224153811.GA16535@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	 <20120224153811.GA16535@kroah.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 10:38 -0500, Greg KH wrote:
> On Fri, Feb 24, 2012 at 10:19:36AM -0500, Jidong Xiao wrote:
> > On Wed, Feb 22, 2012 at 11:56 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> > > Hi,
> > >
> > > I am just curious. Since the concept user-space device drivers has
> > > been proposed for several years, and some related projects and
> > > research papers have demonstrated the feasibility of of moving device
> > > drivers into use space. In particular, this paper:
> > >
> > > Tolerating Malicious Device Drivers in Linux.
> > > http://pdos.csail.mit.edu/papers/sud:usenix10.pdf
> > >
> > > In this paper, existing device driver code need not to be changed,
> > > which should help the idea to be applied in practice.
> > >
> > > The advantage and disadvantage of move device drivers into use space
> > > of both obvious:
> > >
> > > Advantage: Since most of kernel bugs are caused by device drivers
> > > issues, moving device drivers into user space can reduce the impact of
> > > device driver bugs. From security perspective, the system can be more
> > > secure and robust if most device drivers are working in user space.
> > > Disadvantage: At least, existing techniques as well as the above paper
> > > showed a relatively high overhead.
> > >
> > > So is it mainly because the high overhead that prevents the user-space
> > > device drivers ideas being accepted in Linux?
> > >
> > 
> > Actually, my major concern is, since UIO has been accepted, then why
> > don't we move all the rest device drivers into user space as well. As
> > I understand, currently, some of device drivers are running on user
> > space, while the other (or say the majority of) device drivers are
> > running on kernel space, so why don't we maintain a consistent device
> > drivers infrastructure, say, either all in user space, or all in
> > kernel space. (Sure some critical device drivers still need to be kept
> > in kernel space.)
> 
> Feel free to create patches to do so, and handle all of the userspace
> changes needed in order to implement this.
> 
> I think you haven't thought through the true reason we have device
> drivers, and why Linux isn't a microkernel...
> 
> And I'd take exception to your "advantage:" line above, I don't believe
> that is true at all.

I second that. Worse, the real disadvantages are ignored. Crappy
user-space code, code is kept proprietary, code is no longer submitted
upstream, people don't care about implementing interrupts and instead
implement polling loops, porting to later kernel versions is a pain. The
list goes on and on. This is all more than annoying.

I would prefer another approach: Fix the problematic drivers, and spend
time researching how to improve forced module unload to a point where
modules can be re-loaded after an OOPS.

How about dropping UIO support from the kernel ? That would make more
sense to me.

Guenter


