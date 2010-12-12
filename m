Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0LLNkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:40:00 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41032 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0LLNj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hUCW9jKYrSEtPbXnOdnMHkULJVCtli1RJfbcVw8Y9HYP7sxo8BXwr9oNnzJdrk7yDc
         4bJOqQHB0YcfcfwAhJLcTpLmrDWqMZfia/wtQ6Qtb6y0Q5URNRfM2gS2sNtK37lu/sWN
         SrpVPdgWgYyHbZAwXJlULQuaN7p99MSLK/jqA=
MIME-Version: 1.0
In-Reply-To: <20101211234356.1e9007fe@neptune.home>
References: <20101211221325.GA1954@elf.ucw.cz>
	<20101211234356.1e9007fe@neptune.home>
Date: Sun, 12 Dec 2010 21:39:57 +0800
Message-ID: <AANLkTi=q2fbtAwujYv=HzL1zK8jAPefM8pcyGyQSDy5C@mail.gmail.com>
Subject: Re: intelfb refuses to load
From: Dave Young <hidave.darkstar@gmail.com>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        mbroemme@plusserver.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 6:43 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi,
>
> Looks like you are using the wrong intel driver.
>
> For intel modesetting you need
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I830 is not set
> CONFIG_DRM_I915=y
> # CONFIG_DRM_I915_KMS is not set

CONFIG_DRM_I915_KMS=y needed as well?

> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
>
> # CONFIG_FB_I810 is not set
>
> That will give you inteldrmfb.
>                        ^^^
>
> Not sure what dependency is missing in your config that DRM_I915 does
> not show up... (it might be CONFIG_AGP_INTEL)
>
> intelfb (CONFIG_FB_I810) is obsolete and only supports a pretty limited
> part of intel GPU features, modesetting only for VGA output (and not
> sure it works at all with recent GPUs).
>
> Bruno
>
>
> On Sat, 11 December 2010 Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>> I'm trying to fix up my kernel setup so that X is happy... currently
>> it fails to start with:
>>
>> FATAL: Could not load /lib/modules/2.6.37-rc5+/modules.dep: No such
>> file or directory
>> (EE) intel(0): No kernel modesetting driver detected.
>> (EE) Screen(s) found, but none have a usable configuration.
>>
>> So far I have:
>>
>> CONFIG_DRM=y
>> # CONFIG_DRM_TDFX is not set
>> # CONFIG_DRM_R128 is not set
>> # CONFIG_DRM_RADEON is not set
>> # CONFIG_DRM_I810 is not set
>> # CONFIG_DRM_MGA is not set
>> # CONFIG_DRM_SIS is not set
>> # CONFIG_DRM_VIA is not set
>> # CONFIG_DRM_SAVAGE is not set
>> # CONFIG_STUB_POULSBO is not set
>> CONFIG_VGASTATE=y
>> CONFIG_VIDEO_OUTPUT_CONTROL=y
>> CONFIG_FB=y
>> CONFIG_FB_I810=y
>> # CONFIG_FB_I810_GTF is not set
>> # CONFIG_FB_LE80578 is not set
>> CONFIG_FB_INTEL=y
>> CONFIG_FB_INTEL_DEBUG=y
>> CONFIG_FB_INTEL_I2C=y
>> # CONFIG_FB_MATROX is not set
>>
>> And on the command line:
>>
>> BOOT_IMAGE=(hd0,2)/l/linux-good/arch/i386/boot/bzImage root=/dev/sda4
>> resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps
>> psmouse.proto=imps vga=791 init=/tmp/swsusp-init
>> acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1
>> video=intelfb:mode=1024x768 fbcon=scrollback:64k
>>
>> ...but intelfb fails with:
>>
>> [drm] Initialized drm 1.1.0 20060810
>> intelfb: intelfb_init
>> intelfb: Framebuffer driver for Intel(R)
>> 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM
>> chipsets
>> intelfb: Version 0.9.6
>> intelfb: intelfb_setup
>> intelfb: options: mode=1024x768
>> intelfb: intelfb_pci_register
>> intelfb 0000:00:02.0: power state changed by ACPI to D0
>> intelfb 0000:00:02.0: power state changed by ACPI to D0
>> intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> intelfb: fb aperture: 0xd0000000/0x10000000, MMIO region:
>> 0xee100000/0x80000
>> intelfb: Cannot reserve FB region.
>> intelfb: cleanup
>>
>> Any hints? If I'm doing some trivial mistake, perhaps "cannot reserve
>> FB region" message could be improved?
>>                                                                       Pavel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
