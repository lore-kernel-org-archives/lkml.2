Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2BXQi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:38:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53512 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2BXQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:38:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.180.86.9 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224153811.GA16535@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	<20120224153811.GA16535@kroah.com>
Date: Fri, 24 Feb 2012 11:38:54 -0500
Message-ID: <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:38 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 24, 2012 at 10:19:36AM -0500, Jidong Xiao wrote:
>> On Wed, Feb 22, 2012 at 11:56 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
>> > Hi,
>> >
>> > I am just curious. Since the concept user-space device drivers has
>> > been proposed for several years, and some related projects and
>> > research papers have demonstrated the feasibility of of moving device
>> > drivers into use space. In particular, this paper:
>> >
>> > Tolerating Malicious Device Drivers in Linux.
>> > http://pdos.csail.mit.edu/papers/sud:usenix10.pdf
>> >
>> > In this paper, existing device driver code need not to be changed,
>> > which should help the idea to be applied in practice.
>> >
>> > The advantage and disadvantage of move device drivers into use space
>> > of both obvious:
>> >
>> > Advantage: Since most of kernel bugs are caused by device drivers
>> > issues, moving device drivers into user space can reduce the impact of
>> > device driver bugs. From security perspective, the system can be more
>> > secure and robust if most device drivers are working in user space.
>> > Disadvantage: At least, existing techniques as well as the above paper
>> > showed a relatively high overhead.
>> >
>> > So is it mainly because the high overhead that prevents the user-space
>> > device drivers ideas being accepted in Linux?
>> >
>>
>> Actually, my major concern is, since UIO has been accepted, then why
>> don't we move all the rest device drivers into user space as well. As
>> I understand, currently, some of device drivers are running on user
>> space, while the other (or say the majority of) device drivers are
>> running on kernel space, so why don't we maintain a consistent device
>> drivers infrastructure, say, either all in user space, or all in
>> kernel space. (Sure some critical device drivers still need to be kept
>> in kernel space.)
>
> Feel free to create patches to do so, and handle all of the userspace
> changes needed in order to implement this.
>
> I think you haven't thought through the true reason we have device
> drivers, and why Linux isn't a microkernel...
>
> And I'd take exception to your "advantage:" line above, I don't believe
> that is true at all.
>
> Best of luck with your work,
>
Although I was asking "can we" do something, I am not actually
strongly in favor of either move or not move, as indeed it costs too
much to do the moving job.

But when you say "handle all of the userspace changes needed in order
to implement this", if the device driver can be moved without
modification (like the paper above shows), there should not be much
changes required for user space applications.

Also, if user space device drivers is a bad idea, why drivers/uio has
been created and merged into mainline kernel?

Regarding "And I'd take exception to your "advantage:" line above, I
don't believe that is true at all", do you agree that a significant
portion of kernel crash incidents are due to bugs in drivers?

As to "Linux isn't a microkernel", even though the debate between
Linux and microkernel have never stopped, it's hard to deny the fact
that Linux is slowly slowly moving towards a microkernel structure:
LKM, fuse, uio, etc.

Regards
Jidong
