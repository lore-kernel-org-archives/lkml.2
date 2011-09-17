Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1IQPRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:17:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1IQPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
Date: Sat, 17 Sep 2011 10:16:57 -0500
X-Google-Sender-Auth: Ik4N88J8kmGFpyPofS-ENABtrMc
Message-ID: <CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Rob Clark <rob@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linaro-dev@lists.linaro.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 9:44 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Thu, Sep 15, 2011 at 9:58 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> One of my biggest problems with KMS is that it has (naturally) a lot more
>>> complexity than the fb API which leads to instability. Basically it's very
>>
>> It shouldn't do - and a sample of one (your machine) is not a
>> statistically valid set. Fb is pretty much ununsable in contrast on my
>> main box, but that's not a statistically valid sample either.
>>
>> I'm not that convinced by the complexity either. For a simple video card
>> setup such as those that the fb layer can kind of cope with (ie linear
>> buffer, simple mode changes, no client rendering, no vblank flipping,
>> limited mode management, no serious multi-head) a DRM driver is also
>> pretty tiny and simple.
>
> That's not true, many drivers work around the lack of features in the
> fb API by providing custom interfaces. For example, in omapfb it's
> possible to use the overlays from user-space, configure some YUV
> format, do vsink, and multipages just fine:
>
> https://github.com/felipec/gst-omapfb/blob/master/omapfb.c
>
> It's perfect to render video clips. Of course, it would be even better
> if those custom interfaces were merged into the fb API.

fwiw, as was mentioned earlier in the thread, there is already an
effort underway for a standardized overlay interface for KMS:

http://lists.freedesktop.org/archives/dri-devel/2011-April/010559.html

Anyways, it is also possible to extend DRM drivers w/ custom API.. and
even possible extend the fbdev on top of DRM/KMS with custom
interfaces if you *really* wanted to.  I have some patches somewhere
that add support a portion of the omapfb ioctls to the fbdev layer in
omapdrm driver for the benefit of some legacy display test app.  If
someone really wanted to, I guess there is no reason that you couldn't
support all of the omapfb custom ioctls.

>From userspace perspective, fbdev doesn't go away.  It is just a
legacy interface provided on top of DRM/KMS driver mostly via helper
functions.  With this approach, you get the richer KMS API (and all
the related plumbing for hotplug, EDID parsing, multi-head support,
flipping, etc) for userspace stuff that needs that, but can keep the
fbdev userspace interface for legacy apps.  It is the best of both
worlds.  There isn't really any good reason to propagate standalone
fbdev driver anymore.

BR,
-R

> --
> Felipe Contreras
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
