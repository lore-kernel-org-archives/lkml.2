Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0LLMKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:10:40 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60919 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0LLMKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:10:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aefy77kT4b1mkwX/QLQ4rtfcn4qz81Nn1oqVr5np3mrfXADDGS8ArbKKJLuV0sUcgg
         rGpKrHxRquLla0TF4s9S4+Be8RYvXEI/flt9K/1exp2yfp3k1yRh6tfojTyehlbSlil/
         oH/uGGdX3u1LhQeGKDuL9juzh7LAxVWUqRMCk=
MIME-Version: 1.0
In-Reply-To: <20101212080851.GA2254@elf.ucw.cz>
References: <20101211221325.GA1954@elf.ucw.cz>
	<20101211234356.1e9007fe@neptune.home>
	<20101212075203.GA1934@elf.ucw.cz>
	<alpine.DEB.2.00.1012120759520.28614@skynet.skynet.ie>
	<20101212080851.GA2254@elf.ucw.cz>
Date: Sun, 12 Dec 2010 13:10:37 +0100
Message-ID: <AANLkTimmRPcu_Ld7_hBqOrgo4PGDuO6ym0edt7SXz+Je@mail.gmail.com>
Subject: Re: intelfb refuses to load
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Airlie <airlied@linux.ie>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        mbroemme@plusserver.de, linux-fbdev@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 9:08 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k
>> >
>> > on cmdline and:
>> >
>> > CONFIG_DRM=y
>> > CONFIG_DRM_KMS_HELPER=y
>> > # CONFIG_DRM_TDFX is not set
>> > # CONFIG_DRM_R128 is not set
>> > # CONFIG_DRM_RADEON is not set
>> > # CONFIG_DRM_I810 is not set
>> > # CONFIG_DRM_I830 is not set
>> > CONFIG_DRM_I915=y
>> > # CONFIG_DRM_I915_KMS is not set
>> > # CONFIG_DRM_MGA is not set
>> > # CONFIG_DRM_SIS is not set
>> > # CONFIG_DRM_VIA is not set
>> > # CONFIG_DRM_SAVAGE is not set
>> > # CONFIG_STUB_POULSBO is not set
>> > CONFIG_VGASTATE=y
>> > CONFIG_VIDEO_OUTPUT_CONTROL=y
>> > CONFIG_FB=y
>> > CONFIG_FIRMWARE_EDID=y
>> > # CONFIG_FB_DDC is not set
>> > ...
>> > CONFIG_ACPI_VIDEO=y
>>
>> CONFIG_FRAMEBUFFER_CONSOLE?
>
> No, that one was set. (I see even two penguins for a short while).
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> CONFIG_FONTS=y

What works for me (without boot command line options):

[asuardi@duff linux-2.6.37-rc5-git3]$ egrep
'DRM|FB|VIDEO|VGA|FRAMEBUFFER' .config | grep -v "^#"
CONFIG_ACPI_VIDEO=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=4
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_VESA=y
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y

[asuardi@duff linux-2.6.37-rc5-git3]$ dmesg|grep intel
intel_idle: MWAIT substates: 0x3122220
intel_idle: does not run on family 6 model 23
agpgart-intel 0000:00:00.0: Intel GM45 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
fbcon: inteldrmfb (fb0) is primary device
fb0: inteldrmfb frame buffer device


--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
