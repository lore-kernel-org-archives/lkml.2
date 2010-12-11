Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0LKWoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 17:44:20 -0500
Received: from legolas.restena.lu ([158.64.1.34]:57493 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0LKWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 17:44:18 -0500
Date: Sat, 11 Dec 2010 23:43:56 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        mbroemme@plusserver.de
Subject: Re: intelfb refuses to load
Message-ID: <20101211234356.1e9007fe@neptune.home>
In-Reply-To: <20101211221325.GA1954@elf.ucw.cz>
References: <20101211221325.GA1954@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like you are using the wrong intel driver.

For intel modesetting you need
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set

# CONFIG_FB_I810 is not set

That will give you inteldrmfb.
                        ^^^

Not sure what dependency is missing in your config that DRM_I915 does
not show up... (it might be CONFIG_AGP_INTEL)

intelfb (CONFIG_FB_I810) is obsolete and only supports a pretty limited
part of intel GPU features, modesetting only for VGA output (and not
sure it works at all with recent GPUs).

Bruno


On Sat, 11 December 2010 Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
> 
> I'm trying to fix up my kernel setup so that X is happy... currently
> it fails to start with:
> 
> FATAL: Could not load /lib/modules/2.6.37-rc5+/modules.dep: No such
> file or directory
> (EE) intel(0): No kernel modesetting driver detected.
> (EE) Screen(s) found, but none have a usable configuration.
> 
> So far I have:
> 
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_STUB_POULSBO is not set
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FB_I810=y
> # CONFIG_FB_I810_GTF is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_INTEL=y
> CONFIG_FB_INTEL_DEBUG=y
> CONFIG_FB_INTEL_I2C=y
> # CONFIG_FB_MATROX is not set
> 
> And on the command line:
> 
> BOOT_IMAGE=(hd0,2)/l/linux-good/arch/i386/boot/bzImage root=/dev/sda4
> resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps
> psmouse.proto=imps vga=791 init=/tmp/swsusp-init
> acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1
> video=intelfb:mode=1024x768 fbcon=scrollback:64k
> 
> ...but intelfb fails with:
> 
> [drm] Initialized drm 1.1.0 20060810
> intelfb: intelfb_init
> intelfb: Framebuffer driver for Intel(R)
> 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM
> chipsets
> intelfb: Version 0.9.6
> intelfb: intelfb_setup
> intelfb: options: mode=1024x768
> intelfb: intelfb_pci_register
> intelfb 0000:00:02.0: power state changed by ACPI to D0
> intelfb 0000:00:02.0: power state changed by ACPI to D0
> intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> intelfb: fb aperture: 0xd0000000/0x10000000, MMIO region:
> 0xee100000/0x80000
> intelfb: Cannot reserve FB region.
> intelfb: cleanup
> 
> Any hints? If I'm doing some trivial mistake, perhaps "cannot reserve
> FB region" message could be improved?
> 									Pavel
