Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1AYOPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:15:04 -0500
Received: from mailout00.t-online.de ([194.25.134.16]:56358 "EHLO
	mailout00.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1AYOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:15:02 -0500
Message-ID: <4D3EDACF.8040702@t-online.de>
Date: Tue, 25 Jan 2011 15:14:39 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output
 gets disabled/reenabled under load
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com> <4D3EB90C.9020901@t-online.de> <0d30dc$krt8da@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$krt8da@orsmga001.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: VU8QukZFghM7WuwTJs0EvDjoJEXmokcWpUHCIuKQYVmaN1bbpIJHB-jBrscBH4yZEO
X-TOI-MSGID: 9c0f4245-59fc-42d0-b815-8a18a738e14c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I think LOG-2.6.38-rc2 shows a sign of an additional bug
>> ===========================================
>> [  681.527815] [drm:drm_target_preferred], found mode 1280x1024
>> [  681.531482] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
>>
>> Is 4096x4096 really reasonable? I don't think so, at least not for my
>> hardware.
>>     
> Yes, gen3 supports a maximum (square) framebuffer of 4096x4096. X works
> for me with such a virtual screen size (i.e. panning).
>
> The complication comes in that the 3D pipeline is limited to 2048x2048
> coordinates. X tiles, mesa does not and uses software instead. Baring
> bugs, it should work.
>
> If you do have a crash with a recent driver, let me know!
> -Chris
>
>   

Well, I don't know if openSuSE 11.3 is recent enough.
Setup: 2 Monitors, attached to VGA1 and DVI1, resolution 1280x1024

xrandr  --output VGA1 --pos [1..768]
============================
Everything ok. Works as expected.

xrandr --output VGA1 --pos 769
========================
Xorg Log:

[  1936.486]
X.Org X Server 1.8.0
Release Date: 2010-04-02
[  1936.486] X Protocol Version 11, Revision 0
[  1936.486] Build Operating System: openSUSE SUSE LINUX
[  1936.486] Current Operating System: Linux golem 2.6.38-rc2-kape #13
PREEMPT Mon Jan 24 18:31:22 CET 2011 i686
[  1936.486] Kernel command line: root=/dev/sdb5
acpi_enforce_resources=lax drm.debug=0 5
[  1936.486] Build Date: 19 August 2010  03:34:17PM
[...................]
[  2199.625]
Backtrace:
[  2199.625] 0: /usr/bin/Xorg (xorg_backtrace+0x37) [0x80986d7]
[  2199.626] 1: /usr/bin/Xorg (0x8048000+0x4e3fa) [0x80963fa]
[  2199.626] 2: (vdso) (__kernel_rt_sigreturn+0x0) [0xb783640c]
[  2199.626] Segmentation fault at address (nil)
[  2199.626]
Fatal server error:
[  2199.626] Caught signal 11 (Segmentation fault). Server aborting

Nothing special in system log, but drm.loglevel was 0.

cu,
 Knut
