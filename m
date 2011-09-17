Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1IQTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 15:25:26 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:39173 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1IQTZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 15:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <4E74EF98.3060106@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
	<4E74C6C3.2000704@gmx.de>
	<CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
	<4E74E3D6.8080401@gmx.de>
	<CAPM=9txHu7mzH8p8g=FmHsjvmAT-aMy-xEFj4odXEvnbs-bhMw@mail.gmail.com>
	<4E74EF98.3060106@gmx.de>
Date: Sat, 17 Sep 2011 12:25:24 -0700
Message-ID: <CALiqSLe9mV29Qb8c4Kywrcdg702sGjMVHsYPb-Y7v8zKAa4qGQ@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 12:06 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> Again, you seem to not understand my reasoning. The "if" is the problem, it's
> the kernels job to ensure stability. Allowing the userspace to decide whether it
> crashes my machine is not acceptable to me.
> I do not claim that it is impossible to write a KMS driver in a way that it does
> not crash, but it seems more difficult than writing an fbdev driver.

It is a non-trivial problem, which I would argue is impossible, to
permit acceleration without also permitting the possibility of a GPU
lockup. It is completely legal, in every graphics API, to submit
requests which take multiple seconds to render but are totally valid.
Differentiating between long-running rendering and GPU lockup is
difficult. In addition, determining whether or not a permutation of
register writes will lock up a GPU is a pretty hard problem,
computationally, not to mention the walls of code that would be
required to make this happen. At that point, you might as well run
unaccelerated.

>> The core drm/kms ioctls don't expose acceleration to userspace either,
>> again misinformation seems to drive most of your logic. You can't do
>> generic useful acceleration from the kernel. A lot of modern GPU
>> hardware doesn't even have bitblt engines.
>
> I did not say that it is used directly for acceleration, but wasn't the point of
> DRM to allow acceleration in the first place?

In the Voodoo era, sure. DRM really means that userspace can talk
directly to a card, in a card-specific way; beyond the basic DRM
ioctls for gathering card info, nearly every ioctl is device-specific.
You can't command an nV card with Radeon ioctls. It just so happens,
fortunately, that the only things which differ from card to card and
cannot be abstracted from kernel to userspace are accelerated
rendering commands.

You're conflating DRM and KMS. It's possible to provide KMS without
DRM: Modesetting without acceleration.

-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
