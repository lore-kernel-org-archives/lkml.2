Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1CLRBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:01:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64111 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1CLRBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:01:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fAxvaB4yTB8ub1mbubljAJh9XyVzdk+0Tm+pKqJRpwOjN6tk+dxcOMujTeHvjuOJ+j
         ecanujx36ppkrr7KXgsB1aTCew/+s9T4qhPspu30yfPAZ6+Js/qEwIxwQWIA+tNncNvB
         gg6x+9APUtEbHm6GQFiuWRtEqAyE6+Esjy1uM=
MIME-Version: 1.0
In-Reply-To: <20110311193440.754b9636@lxorguk.ukuu.org.uk>
References: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
	<20110311193440.754b9636@lxorguk.ukuu.org.uk>
Date: Sat, 12 Mar 2011 12:01:17 -0500
Message-ID: <AANLkTi=mvLWd2eOgNc3L9swduoxJMhPO4_5C3Sfu5EwC@mail.gmail.com>
Subject: Re: How to use gma500 framebuffer driver?
From: Greg Brigley <gbrigley@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks guys.  I went to retrieve a dmesg dump for Alan, and thought I
should really do it without some other modules I had loaded, so the
output would be less cluttered.  When I did that, the framebuffer
worked!

I'll figure out which other module was causing the trouble and report back.

As for the mirrored display, is this something I might reasonably take
on myself, having no experience with  video drivers?  If so, pointers
for where to start looking would be great.

Greg



On Fri, Mar 11, 2011 at 2:34 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> 0e83f46d3869a5255a04b875bb885bd141a609ef, from Feb 26 - the last
>> commit on drivers/staging/gma500, and now I can build successfully,
>> but have not succeeded in producing video output.
>
> Currently it works on the Dell mini 10 and some other panels, but I know
> it's not yet working on quite a few other setups.
>
>> I guess I'll start by saying what I'm trying to do, to make sure I'm
>> not misguided in trying this in the first place.  I want to run Xfbdev
>> and drive both an LVDS and HDMI display at the same time (mirrored).
>> I don't need 2d or 3d acceleration.  I don't see an indication that
>> anyone else has tried mirrored displays with this driver, and I don't
>> mind being the first, but should it work in theory?  If it's not
>> supported, would it be difficult to add?
>
> It's on the todo list, as is non mirrored dual display.
>
>> So here are my questions for those who have used the staging driver:
>> * Should I be compiling it as a module, or as part of the kernel?
>
> Either - it's probably best tested as a module for the moment
>
>> * If I'm compiling it as a module, is there some sort of incantation
>> to make the framebuffer device show up when I insert the module?
>
> That would be the default behaviour providing it manages to set up the
> port. If it doesn't it will stay in text mode
>
>> Currently, when I insmod psb_gfx.ko, nothing appears in /proc/fb, or
>> in /dev.  I'm using udev.  If I do "mknod /dev/fb0 c 29 0", then both
>> fbset and Xfbdev give me "no such device" errors.
>
> What shows up in "dmesg" ?
>
> Alan
>
