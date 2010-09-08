Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0IHPwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:52:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43318 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0IHPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cThVrtKgq77S9XspF5X+kvPldMCDKvzjZcLWU6rKM9EY3vkaGEMqiQ28/ONkDTv87U
         gRrwGhFu5ofe6sDx7qom3/9rAKKtrTnM+8CiD2p1kptaxNIkEDaZMHJpo6dG0ymhYhf7
         ZYPirNsXuSBGXhnyCzVvwP0p9E9IiwfN4T388=
MIME-Version: 1.0
In-Reply-To: <8u3s8d$jgt7hk@orsmga001.jf.intel.com>
References: <AANLkTim2mrVRCKg-2couMTFV7krHQp0+2e_cbaiT_KYW@mail.gmail.com>
	<8u3s8d$jgt7hk@orsmga001.jf.intel.com>
Date: Wed, 8 Sep 2010 11:52:01 -0400
Message-ID: <AANLkTinFJFSq01N2cko__4vYXJEH7o3OUeLG86Y-8T64@mail.gmail.com>
Subject: Re: [regression] i915 incorrectly detects bogus LVDS connection
 instead of LVDS1
From: Woody Suwalski <terraluna977@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 8 Sep 2010 11:10:42 -0400, Woody Suwalski <terraluna977@gmail.com> wrote:
>> LVDS connected 800x600+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
>> LVDS-1 connected 800x600+0+0 (normal left inverted right x axis y
>
> The -intel driver does not generate either of these names, it strictly
> uses "%s%d" or "UNKNOWN" for the output name. Maybe an Xorg.log would
> help identify the issue?
>
> --
> Chris Wilson, Intel Open Source Technology Centre
>

Correct about naming.
However it is same X, only the kernel is changed.
The issue is that kernel reports 2 displays connected, when in fact
there is only one.

Here is the part from Xorg.log on 2.6.36:
(II) intel(0): Creating default Display subsection in Screen section
        "Builtin Default intel Screen 0" for depth/fbbpp 24/32
(==) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) 945GME
(--) intel(0): Chipset: "945GME"
(--) intel(0): Linear framebuffer at 0xC0000000
(--) intel(0): IO registers at addr 0xDFE80000 size 524288
(WW) intel(0): libpciaccess reported 0 rom size, guessing 64kB
(II) intel(0): the SDVO device with slave addr 70 is found on DVO 1 port
(II) intel(0): 2 display pipes available.
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) intel(0): Output VGA has no monitor section
(II) intel(0): Output LVDS has no monitor section
(II) intel(0): I2C bus "LVDSDDC_C" initialized.
(II) intel(0): Attempting to determine panel fixed mode.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): EDID for output LVDS
(II) intel(0): found backlight control method /sys/class/backlight/acpi_video0
xf86TokenToOptinfo: table is NULL
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B"
registered at address 0x70.
(II) intel(0): I2C bus "SDVOB DDC Bus" initialized.
(II) intel(0): Output LVDS-1 has no monitor section
(II) intel(0): SDVOB: device VID/DID: 02:41.01, clock range 25.0MHz - 200.0MHz
(II) intel(0): SDVOB: 1 input channel
(II) intel(0): SDVOB: LVDS0 output reported
xf86TokenToOptinfo: table is NULL
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C"
registered at address 0x72.
(II) intel(0): No SDVO device found on SDVOC
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" removed.
(II) intel(0): Current clock rate multiplier: 1

The real issue is that kernel is most likely crashing if KMS is used -
I can see big cursor before KMS, then cursor disappears (if I run in
noquiet mode, the last line will be about drm), and from now on I have
a black screen. Can not ssh into the box, so probably is dead... No
USB kbd seems alive - X input was not run either?
As such - the box is undebugable...

I agree that probably hardware is wired incorrectly, yet "the other
OS" seems to cope with it.
As were kernels 2.6.33...2.6.35.

I just checked the history - I had to backport LVDS detection from
2.6.33 to 2.6.32 to make it work.

Thanks, Woody
