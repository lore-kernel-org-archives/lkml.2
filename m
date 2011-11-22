Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1KVCjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:39:20 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34472 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1KVCjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <86ipmdgcjo.fsf@sumi.keithp.com>
References: <alpine.LNX.2.00.1111151301410.2693@darkstar.example.net>
 <alpine.LNX.2.00.1111191124350.5248@darkstar.example.net> <864ny0kku8.fsf@sumi.keithp.com>
 <alpine.LNX.2.00.1111212248140.2070@darkstar.example.net> <86ipmdgcjo.fsf@sumi.keithp.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 22 Nov 2011 00:38:58 -0200
Message-ID: <CAKi4VAL-BO=4duQ18o-sQ8h4V8_-1LPg1g+QxZoTEJzp0FBJ+w@mail.gmail.com>
Subject: Re: max PWM is zero
To: Keith Packard <keithp@keithp.com>
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 23:40, Keith Packard <keithp@keithp.com> wrote:
> On Mon, 21 Nov 2011 22:48:21 +0000 (Local time zone must be set--see zic manual page), Marcos Paulo de Souza <marcos.mage@gmail.com> wrote:
>
>> My max_brightness is 1, and my brightness is 0.
>
> Right, we've prevented the internal backlight driver from exposing a max
> value of 0 as that's just confusing.
>
>> But, my acpi_video0 have a
>> max_brightness value = 9...
>
> Right, sounds like your device is just using some other backlight
> controller, which is perfectly reasonable.
>
>> So, what can I do to silence this warning...? Change the driver of
>> backlight?
>
> If your backlight keys work correctly, then things are fine and perhaps
> we should just remove the warning from the driver, or disable the
> internal driver when we discover this situation.
>
> This is the first time I've heard of this warning appearing...

It appears here as well. I think it was since 2.6.39 or 3.0, I'm not sure.

Same card:

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
	Subsystem: Dell Device 02bb
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at f6400000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
	Subsystem: Dell Device 02bb
	Flags: bus master, fast devsel, latency 0
	Memory at f6100000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3

My kernel log has:

[drm] Driver supports precise vblank timestamp query.
composite sync not supported
fixme: max PWM is zero.
composite sync not supported


Is this "composite sync not supported" related to this issue?


Lucas De Marchi
