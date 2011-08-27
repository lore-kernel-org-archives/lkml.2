Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1H0XDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 19:03:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63705 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1H0XDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 19:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1314435638.2321.12.camel@thor.local>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 27 Aug 2011 19:03:22 -0400
Message-ID: <CAGZ=bqKizV5rkeca67z-HdRJ_CayvYh+HHgf=LzUTpoxSwpZ2A@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Pavel Ivanov <paivanof@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/27 Michel Dänzer <michel@daenzer.net>:
> On Sam, 2011-08-27 at 00:20 -0400, Pavel Ivanov wrote:
>> I observe very strange behavior dependent on value of
>> CONFIG_DRM_RADEON parameter. When it's set to m everything works very
>> good, no problem. When I set it to y I see kernel hang during boot. Or
>> I should better say it "almost hangs" because during last boot attempt
>> I accidentally waited a little bit longer and saw that after more than
>> a minute waiting system continued to boot. Dmesg after "hang" shows
>> these messages:
>>
>> [    8.542639] [drm] Loading CEDAR Microcode
>> [   69.161605] r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
>> [   69.161670] [drm:evergreen_startup] *ERROR* Failed to load firmware!
>>
>> While during normal boot
>>
>> [    9.898870] [drm] Loading CEDAR Microcode
>> [    9.908425] radeon 0000:05:00.0: WB enabled
>
> With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> loaded from userspace, so it needs to be built into the kernel as well.

Linus has gotten pissed previously about drivers that do this.

I actually recall a patch previously that made request_firmware() fail instantly
before userspace is loaded, which would get rid of the hang, but presumably
not actually make the driver work when built-in.

The solution is to allow the driver to "attach" to the device but if
the firmware is
not available at that time then retrying the request_firmware() later, ideally
triggered from some userspace action.

Cheers,
Kyle Moffett
