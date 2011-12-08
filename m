Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1LHIb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:31:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42256 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab1LHIbX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <b92a2d1d30910b75f3354926d9fa26f6.squirrel@host171.canaca.com>
References: <4EDFD23D.4030703@xenotime.net>
	<1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
	<b92a2d1d30910b75f3354926d9fa26f6.squirrel@host171.canaca.com>
Date: Thu, 8 Dec 2011 09:31:20 +0100
Message-ID: <CANq1E4T6uoezonoaBk6agD4-6A7QMSiP0ySDPg+5r50G8LYWTA@mail.gmail.com>
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
From: David Herrmann <dh.herrmann@googlemail.com>
To: simon@mungewell.org
Cc: linux-input@vger.kernel.org, rdunlap@xenotime.net,
        linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 10:07 PM,  <simon@mungewell.org> wrote:
>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index edf2b2b..dae04a0 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -591,6 +591,7 @@ config HID_WIIMOTE
>>       depends on BT_HIDP
>>       depends on LEDS_CLASS
>>       select POWER_SUPPLY
>> +     select INPUT_FF_MEMLESS
>>       ---help---
>>       Support for the Nintendo Wii Remote bluetooth device.
>
> I don't mean to be a complainer, but shouldn't the WiiMote module depend
> on FF_MEMLESS rather than just forcing it on.

I have considered that but "grep -r FF_MEMLESS" returned no other
driver using "depend" so I decided to use "select", too.

> The module could also #define the appropriate bits so that FF_MEMLESS was
> only used when available, the rumble motor is a very small part of the
> WiiMote's feature set.
>
> Some people might not want FF_MEMLESS enabled.

Why? It is a really small feature that depends only on CONFIG_INPUT.
Just 600 lines of code. I don't see why someone who wants to enable
the way bigger wiimote driver and HID core would bother about
FF_MEMLESS? Why should someone want to disable the rumble-feature of
the wiimote?
I cannot see any real use-case here. Maybe you can explain a bit more.

> Simon.
>

Cheers
David
