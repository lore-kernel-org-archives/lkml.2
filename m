Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab1IOTpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:45:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64499 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934664Ab1IOTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E724F93.1050203@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<4E724F93.1050203@gmx.de>
Date: Thu, 15 Sep 2011 15:45:48 -0400
Message-ID: <CADnq5_Neey+BOKQPnQe1ur2=izcV7YynHPkGgjz5ZuzZMr4eAQ@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Alex Deucher <alexdeucher@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Keith Packard <keithp@keithp.com>,
        linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 3:18 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> On 09/15/2011 06:58 PM, Alan Cox wrote:
>>> Well, I rather think that the fb API is more user centric to allow every program
>>> to use it directly in contrast to the KMS/DRM API which aims to support every
>>> feature the hardware has. For this the fb API should not change much, but I
>>> understand some additions were needed for some special users, probably limited
>>> to X and wayland.
>>
>> Wayland needs vblank frame buffer switching and the like. Likewise given
>> you want to composite buffers really any serious accelerated device ends
>> up needing a full memory manager and that ends up needing a buffer
>> manager. Wayland needs clients to be doing their own rendering into
>> objects which means authorisation and management of the render engine
>> which ends up looking much like DRM.
>
> As you have DRM now and as I'm not interested in wayland I won't discuss this,
> but I guess it might be a good start for Geert's question what would be needed
> to use it on dumb framebuffers.
>
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
> Yes, if you limit DRM to the functionality of the fb API I guess you could reach
> the same stability level. But where can I do this? Where is a option to forbid
> all acceleration or at least limit to the acceleration that can be done without
> any risk?

Right now most of the KMS DRM drivers do not support accelerated fb,
so as long as you don't run accelerated X or a 3D app, it should be
just as stable as an fb driver.  You may run into modesetting fail in
certain cases due to wonky hardware or driver bugs, but you will hit
that with an fb driver as well.

Alex
