Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2B1Icp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:32:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46110 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2B1Icn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:32:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@ffwll.ch designates 10.180.107.99 as permitted sender) smtp.mail=daniel@ffwll.ch; dkim=pass header.i=daniel@ffwll.ch
Date: Tue, 28 Feb 2012 09:32:48 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: regression(?) 3.3-rc4 -> 3.3-rc5: drm intel hangs
Message-ID: <20120228083248.GA4249@phenom.ffwll.local>
Mail-Followup-To: Norbert Preining <preining@logic.at>,
	linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <20120228040327.GA9973@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228040327.GA9973@gamma.logic.tuwien.ac.at>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 01:03:27PM +0900, Norbert Preining wrote:
> Dear all,
> 
> (please Cc)
> 
> since upgrade to 3.3-rc5 I see the following behaviour repeatedly:
> 
> Feb 28 11:42:47 mithrandir kernel: [15627.756071]
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> Feb 28 11:42:47 mithrandir kernel: [15627.756087] [drm] capturing error
> event; look for more information in /debug/dri/0/i915_error_state

Wee need this i915_error_state file from debugfs (you might need to mount
that first again) to diagnose gpu hangs. Also, it only contains
information after a crash, so you need to rehang your machine if you've
rebooted since then.

Thanks, Daniel

> Feb 28 11:42:47 mithrandir kernel: [15627.758428] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 7 at 4, next 8)
> Feb 28 11:42:47 mithrandir kernel: [15628.260094] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> Is this is known issue?
> 
> hardware Intel GM45 Chipset
> more dmesg parts:
> [    0.566805] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
> [    0.566925] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    0.569079] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
> [    0.569278] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
> ...
> [    2.032297] [drm] Initialized drm 1.1.0 20060810
> [    2.032372] i915 0000:00:02.0: power state changed by ACPI to D0
> [    2.032429] i915 0000:00:02.0: power state changed by ACPI to D0
> [    2.032489] i915 0000:00:02.0: setting latency timer to 64
> [    2.085250] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> [    2.085260] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    2.085318] [drm] Driver supports precise vblank timestamp query.
> [    2.085439] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
> [    2.085527] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    2.769842] fbcon: inteldrmfb (fb0) is primary device
> [    2.771391] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
> [    3.304756] Console: switching to colour frame buffer device 200x56
> [    3.308853] fb0: inteldrmfb frame buffer device
> [    3.308855] drm: registered panic notifier
> [    3.329552] acpi device:01: registered as cooling_device2
> [    3.329713] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
> [    3.329766] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
> [    3.329881] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> LUPPITT (n.)
> The piece of leather which hangs off the bottom of your shoe before
> you can be bothered to get it mended.
> 			--- Douglas Adams, The Meaning of Liff
> 
> ------------------------------------------------------------------------------
> Keep Your Developer Skills Current with LearnDevNow!
> The most comprehensive online learning library for Microsoft developers
> is just $99.99! Visual Studio, SharePoint, SQL - plus HTML5, CSS3, MVC3,
> Metro Style Apps, more. Free future releases when you subscribe now!
> http://p.sf.net/sfu/learndevnow-d2d
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
