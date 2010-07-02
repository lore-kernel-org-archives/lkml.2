Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0GBANS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:13:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44402 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab0GBANQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OV9hO5NeTGY57mcHRy8gQLuP2EeBbhDGc8nkIzc30IcTyfBOZvVpJDmuJfmMRbzR9H
         huRXaXGWvOV1EkrZ+bAZV8Flt03Vnu4/tg+bWvqx30sHc4t8bK8znQ/ij7e/GX/rHVSS
         vwvsDEPYMVCHYVZZxVVCSUM/TNoOnm5nA152I=
MIME-Version: 1.0
In-Reply-To: <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	<1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
	<1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
	<1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
Date: Fri, 2 Jul 2010 10:13:11 +1000
Message-ID: <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 10:08 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2010-07-02 at 09:37 +1000, Dave Airlie wrote:
>
>> > Oh, man .. It seems like any driver model that straddles userspace and
>> > kernel space is kind of asking for trouble (my opinion anyway)..
>> >
>> > Would you accept a userspace component that supported some subset of the
>> > features ? You would have a kernel space driver, and userspace both open
>> > source and GPL'd , but the userspace component wouldn't support ever
>> > feature available .. Then the company would be free to make another
>> > proprietary userspace with more features based off the open source one.
>> >
>>
>> That starts to get a bit more towards useful, except you still run
>> into the problem of what happens if community developers start adding
>> features to the open driver, that conflict with  features in the
>> closed code. We'd also have to be very careful about what interfaces
>> the kernel exposed had corresponding code in userspace. i.e. adding
>> "special" ioctls for the closed bits would be a disaster, all such
>> ioctls would need open users for verification and testing.
>
> Ok .. The open userspace would just be like any other project, but
> whatever company pushed the driver would likely maintain the userspace
> component .. So the maintainer would have to handle the conflicts
> between the proprietary vs. open source sides of it.
>
> Actually , now that I think about it the biggest problem is the license
> of the userspace side.. Whatever company makes this would have to be
> able to relicense it and actually make a proprietary userspace.. So the
> userspace license would be really critical.. Either that or no one
> outside the company that pushed the driver could make code changes to
> the userspace side..

We generally use MIT for userspace bits anyways, I don't think we have
any LGPL/GPL drivers in userspace currently. So this would probably be
an okay solution to continue with.

The thing is with architectures like Gallium it would be possible to
write a complete open driver and just keep the Windows interface bits,
granted we don't have an open gallium to windows driver layer so that
would have to be worked on.

>
>> So for example, if you have a kernel KMS/DRM driver, and it set the
>> hardware up, but then you had an open 2D driver and a closed 3D
>> driver, you would have to make sure there was no functionality in the
>> kernel that only the 3D driver used as it would become impossible to
>> openly validate it.
>
> Ok. I'm not sure how crazy that would be to setup, but it doesn't seem
> like it would be that hard to just abstract the various components of
> the driver.

Its pretty much what something like gallium can do.

>
>> The other issue I see with a lot of these, is the driver are presented
>> as this is the kernel driver, these APIs are set in stone as we have
>> binary userspaces already deployed, this is even more unacceptable,
>> since we need to be able to change the interface and do proper driver
>> design before merging what looks like crap thrown together in a pile
>> and made to stick.
>
> This seems really wild to me .. Your talking about how you change the
> kernel space side and you need to be able to change the userspace side
> to match right ?
>
> Where does the userspace side of these driver live? Not in the kernel
> right?

This is more about initial development stages. We maintain kernel
API/ABI for all in-tree drivers, however before we put a driver into
mainline, we usually need to redo the crazy interfaces that vendors
have come up with. Like 32/64 alignment, passing userspace addresses
into the kernel, passing phy addresses to userspace etc. If the
userspace binary is closed that process becomes next to impossible.

Dave.
