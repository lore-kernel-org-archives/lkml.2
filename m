Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0GAXiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:38:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59208 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0GAXh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AxwaVrVA8zJrFWgFUwXWvM+d5Qfdx1T1V2h9jR7VliLueY1yuTafSweFq54LXmiwRe
         SOYu9InE1iKgNi+Z3M+y7haHP7XHzP2d7HPEibFvCsBXObxi+OFZbqGBE62oaQe2axXn
         kCGFOQ0tIH5F3UxdoQQRMQgFNb2r5P9sxfuRA=
MIME-Version: 1.0
In-Reply-To: <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	<1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
	<1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
Date: Fri, 2 Jul 2010 09:37:58 +1000
Message-ID: <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 9:29 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2010-07-02 at 08:57 +1000, Dave Airlie wrote:
>> On Fri, Jul 2, 2010 at 8:51 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
>> > On Fri, 2010-07-02 at 08:36 +1000, Dave Airlie wrote:
>> >> On Fri, Jul 2, 2010 at 8:10 AM, Dave Airlie <airlied@gmail.com> wrote:
>> >> > Now this is just my opinion as maintainer of the drm, and doesn't
>> >> > reflect anyone or any official policy, I've also no idea if Linus
>> >> > agrees or not.
>> >> >
>> >> > We are going to start to see a number of companies in the embedded
>> >> > space submitting 3D drivers for mobile devices to the kernel. I'd like
>> >> > to clarify my position once so they don't all come asking the same
>> >> > questions.
>> >> >
>> >> > If you aren't going to create an open userspace driver (either MIT or
>> >> > LGPL) then don't waste time submitting a kernel driver to me.
>> >
>> > If , for whatever reason, you changed you mind on this what sort of
>> > connection between kernel and userspace would these components use?
>> >
>> > I ask only because I think UIO hold most (if not all) the driver in
>> > userspace .. So you would have to use some other interface if you wanted
>> > a more half and half solution ..
>> >
>>
>> The thing is UIO doesn't solve the problem 3D graphics drivers need to
>> solve. Which is we need to let unprivileged users access the graphics
>> device in an efficient manner, hence why DRI/DRM exists. Now I think
>> the tegra guys have done some evil hacks with a userspace daemon to
>> replace the kernel functionality, so all they have in-kernel is a
>> framebuffer device, since they can't really get away with shipping the
>> binary nvidia driver linked to the kernel in a real device. So all
>> their userspace closed bits talk to the daemon running as root with
>> direct access to the lowlevel hw.
>
> Oh, man .. It seems like any driver model that straddles userspace and
> kernel space is kind of asking for trouble (my opinion anyway)..
>
> Would you accept a userspace component that supported some subset of the
> features ? You would have a kernel space driver, and userspace both open
> source and GPL'd , but the userspace component wouldn't support ever
> feature available .. Then the company would be free to make another
> proprietary userspace with more features based off the open source one.
>

That starts to get a bit more towards useful, except you still run
into the problem of what happens if community developers start adding
features to the open driver, that conflict with  features in the
closed code. We'd also have to be very careful about what interfaces
the kernel exposed had corresponding code in userspace. i.e. adding
"special" ioctls for the closed bits would be a disaster, all such
ioctls would need open users for verification and testing.

So for example, if you have a kernel KMS/DRM driver, and it set the
hardware up, but then you had an open 2D driver and a closed 3D
driver, you would have to make sure there was no functionality in the
kernel that only the 3D driver used as it would become impossible to
openly validate it.

The other issue I see with a lot of these, is the driver are presented
as this is the kernel driver, these APIs are set in stone as we have
binary userspaces already deployed, this is even more unacceptable,
since we need to be able to change the interface and do proper driver
design before merging what looks like crap thrown together in a pile
and made to stick.

Dave.
