Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1ACXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:09:57 -0500
Received: from mailout09.t-online.de ([194.25.134.84]:37324 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1ACXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:09:55 -0500
Message-ID: <4D22571F.9060706@t-online.de>
Date: Tue, 04 Jan 2011 00:09:19 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, airlied@linux.ie,
        eric@anholt.net, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de,
        "'Jean Delvare'" <khali@linux-fr.org>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com> <4D22119B.9050007@t-online.de> <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com> <849307$b0clt4@azsmga001.ch.intel.com>
In-Reply-To: <849307$b0clt4@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: EIJmT2ZlrhK5mRy3LN2f+IQ41aqFvfvjI9csSIYh4XsgofBlqC3THSxAb8+o+xCg6P
X-TOI-MSGID: 11fdf88e-eb8c-44a8-921f-fd34e426be44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.01.2011 20:59, schrieb Chris Wilson:

So I did some additional compiles and tests. The distribution used is
openSuSE 11.3.

openSuSE 11.3 kernel
=================
System locks up while starting X, hard reset is needed.


Kernel 2.6.31.14
=============

VGA and DVI connectors do work as expected.
xrandr shows VGA1, DVI1, TV1 and TV2. Thats correct, these are the
connectors
present on the i915GMm-HFS mobo. But read from boot.msg:

agpgart-intel 0000:00:00.0: Intel 915GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[i915_sdvo:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range
25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[i915_sdvo:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range
25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[drm] TV-12: set mode NTSC 480i 0
render error detected, EIR: 0x00000010
page table error
PGTBL_ER: 0x00000010
[drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
render error detected, EIR: 0x00000010
page table error
PGTBL_ER: 0x00000010
[drm] DAC-6: set mode 1280x1024 2c
[drm] TMDS-8: set mode 1280x1024 2d
Console: switching to colour frame buffer device 160x64
[drm] fb0: inteldrmfb frame buffer device
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


Kernel 2.6.37-rc8-git2
=================

text mode console: ok, resolution 1280x1024, fully used by framebuffer
output
X: first device detected is LVDS with resolution 1024x768. VGA and DVI
connector work in X,
but X switches to 1024x768 for both of them. xrandr reports the four
physical connectors but
also LVDS, VGA2 and TV3 connectors.


Kernel 2.6.37-rc8-git2 + patch Chris Wilson
=================================

VGA connector broken for both framebuffer console and X. No signal,
monitor switches off. xrandr does
not report the connected monitor.

DVI connector does work, but: physical resolution for framebuffer
console is 1280x1024, text output
is done on the top left 1024x768. X switches to 1024x768 resolution ;-(

LVDS, VGA2 and TV3 reported by xrandr although these are not present.


Kernel 2.6.37-rc8-git2 + patch Knut Petersen
==================================
Both VGA and DVI connectors work as expected, monitor is correctly
recognized,
framebuffer console and X use maximum possible resolution. No page table
errors
as in 2.6.31.14. LVDS does not show up in xrandr output, but VGA2 and
TV3 are
still detected.


Kernel 2.6.37-rc8-git2 + patches Knut Petersen and Chris Wilson
==================================================
no difference to  2.6.37-rc8-git2 + patch Knut Petersen


Conclusion
=========
With my patch I do cure the symptoms for at least the 2.6.36.2 and
2.6.37-rc8-git2 kernels.
Maybe that's the right thing to do now, but if someone could cure the
real cause of the problem it
would be an even better idea.

Knut

> On Mon, 3 Jan 2011 11:45:48 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>   
>> On Mon, Jan 3, 2011 at 10:12 AM, Knut Petersen
>> <Knut_Petersen@t-online.de> wrote:
>>     
>>> I tried 2.6.37-rc8-git2 with both patches applied.
>>>       
>> I thought Chris meant "instead of", rather than "both". Chris?
>>     
> Right, I was trying to ascertain whether the intel_lvds_ddc_probe()
> correctly detected the missing panel. That function currently requires
> GMBUS to differentiate between a NAK and an IO error (bitbanging just
> returns EREMOTEIO regardless, iirc). So far it has been successful in
> detecting one false-positive for an AOpen All-in-one and hasn't fouled
> up LVDS detection for the laptops I have.
> -Chris
>
>   

