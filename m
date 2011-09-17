Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1IQVZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 17:25:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1IQVZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 17:25:13 -0400
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
Date: Sat, 17 Sep 2011 17:25:12 -0400
Message-ID: <CADnq5_OYLwPPAQOAG3N1rQRZ49JZTKpXVVHePPXFA-jR-a9wHw@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Alex Deucher <alexdeucher@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 3:06 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> On 09/17/2011 06:23 PM, Dave Airlie wrote:
>>>
>>> Is it? Well, okay, I don't want to use any acceleration that can crash my
>>> machine, where can I select it, preferably as compile time option? I didn't find
>>> such a thing for Intel or Radeon. Don't say, I should rely on userspace here or
>>> use fbdev for this.
>>
>> Just tell the X driver to not use acceleration, and it you won't get
>> any acceleration used, then you get complete stability. If a driver
>> writer wants to turn off all accel in the kernel driver, it can, its
>> not an option we've bothered with for intel or radeon since it really
>> makes no sense. To put it simply you don't really seem to understand
>> the driver model around KMS. If no userspace app uses acceleration
>> then no acceleration features will magically happen. If you want to
>> write a simple app against the KMS API like plymouth you can now use
>> the dumb ioctls to create and map a buffer that can be made into a
>> framebuffer. Also you get hw cursors + modesetting.
>
> Again, you seem to not understand my reasoning. The "if" is the problem, it's
> the kernels job to ensure stability. Allowing the userspace to decide whether it
> crashes my machine is not acceptable to me.
> I do not claim that it is impossible to write a KMS driver in a way that it does
> not crash, but it seems more difficult than writing an fbdev driver.
>

It's perfectly valid to write a KMS DRM driver that doesn't support
acceleration in which case it will be just as "stable" as a fbdev
driver.  In fact on modern hardware it's probably easier to write a
KMS DRM driver than a fbdev driver because the API and internal
abstractions match the hardware better.  If you have hardware with 4
display controllers, 2 DACs, a TMDS encoder, and a DP encoder how do
you decide which combination of components and modes to light up at
boot using fbdev?

Alternatively, if you wanted to support acceleration as well, you can
add a module option to force acceleration off at the kernel level
rather than from userspace.  It's trivial.

Alex
