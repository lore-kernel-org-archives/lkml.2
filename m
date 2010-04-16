Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab0DPMBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:01:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48187 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0DPMBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:01:36 -0400
From: <samu.p.onkalo@nokia.com>
To: <marcin@derlukiewicz.pl>, <jkosina@suse.cz>, <eric.piel@tremplin-utc.net>
CC: <akpm@linux-foundation.org>, <pavel@ucw.cz>, <lm-sensors@lm-sensors.org>,
       <linux-kernel@vger.kernel.org>
Date: Fri, 16 Apr 2010 14:00:15 +0200
Subject: RE: [PATCH] lis3lv02d: provide means to disable polled input
 interface
Thread-Topic: [PATCH] lis3lv02d: provide means to disable polled input
 interface
Thread-Index: AcrdWd0DseU83KcJTquojGMiu9I2dgAAh6MA
Message-ID: <62697B07E9803846BC582181BD6FB6B826A8525E8A@NOK-EUMSG-02.mgdnok.nokia.com>
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
 <4BBF2BD1.5050107@tremplin-utc.net>
 <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
 <op.va86rulwgp7y00@linux-r26l.site>
In-Reply-To: <op.va86rulwgp7y00@linux-r26l.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: ECmX Kjdb XZYk YHIW Z3JP biPb eJrh iH5x kJsI kz7D o6Ls
 wSHH 1JiN 1yhN 6x38
 6/NI;7;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGUAcgBpAGMALgBwAGkAZQBsAEAAdAByAGUAbQBwAGwAaQBuAC0AdQB0AGMALgBuAGUAdAA7AGoAawBvAHMAaQBuAGEAQABzAHUAcwBlAC4AYwB6ADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAbQAtAHMAZQBuAHMAbwByAHMAQABsAG0ALQBzAGUAbgBzAG8AcgBzAC4AbwByAGcAOwBtAGEAcgBjAGkAbgBAAGQAZQByAGwAdQBrAGkAZQB3AGkAYwB6AC4AcABsADsAcABhAHYAZQBsAEAAdQBjAHcALgBjAHoA;Sosha1_v1;7;{B5385E81-7E27-4C22-9156-954D9F939B98};cwBhAG0AdQAuAHAALgBvAG4AawBhAGwAbwBAAG4AbwBrAGkAYQAuAGMAbwBtAA==;Fri,
 16 Apr 2010 12:00:15
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbABpAHMAMwBsAHYAMAAyAGQAOgAgAHAAcgBvAHYAaQBkAGUAIABtAGUAYQBuAHMAIAB0AG8AIABkAGkAcwBhAGIAbABlACAAcABvAGwAbABlAGQAIABpAG4AcAB1AHQAIABpAG4AdABlAHIAZgBhAGMAZQA=
x-cr-puzzleid: {B5385E81-7E27-4C22-9156-954D9F939B98}
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Apr 2010 12:00:35.0151 (UTC) FILETIME=[6BF63DF0:01CADD5C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3GC1kmE005343



>-----Original Message-----
>From: ext Marcin Derlukiewicz [mailto:marcin@derlukiewicz.pl]
>Sent: 16 April, 2010 14:42
>To: Jiri Kosina; √âric Piel
>Cc: Andrew Morton; Onkalo Samu.P (Nokia-D/Tampere); Pavel Machek; lm-
>sensors@lm-sensors.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input
>interface
>
>Dnia 09-04-2010 o 15:32:59 Jiri Kosina <jkosina@suse.cz> napisa≈Ç(a):
>
>> On Fri, 9 Apr 2010, √âric Piel wrote:
>>
>>> > This is reported to create 20% CPU usage increase (and
>proportionaly
>>> higher
>>> > power consumption) just for the ipolldevd kernel thread (which is
>used
>>> > to read the sensor).
>>> >
>>> > As most users probably only use the freefall functionality of the
>>> driver
>>> > and not the joystick interface, provide means for disabling the
>>> registration
>>> > of joystick device altogether via module parameter.
>>> > (I'd rather make it default to 0, but this will break backwards
>>> compatibility).
>>> Are you saying there is a 20% CPU usage even when the joystick
>interface
>>> is not open? This should not happen (and this is not happening on my
>>> laptop). The polling should happen only when a userspace app opens
>the
>>> joystick interface (like running neverball).
>>>
>>> So I'd tend to think it's more due to a misconfiguration of the
>system
>>> (like xserver using the joystick interface as a pointer device) or
>it's
>>> a bug in the way we set up the polling. Could you investigate and let
>me
>>> know?
>>
>> Marcin originally reported this to me.
>>
>> Marcin, could you please check 'lsof' output to see whether the
>joystick
>> interface has been open by some application?
>>
>> Thanks,
>>
>
>sorry for the delay, had a crunch time
>
>here is the link for this lsof:
>https://bugzilla.novell.com/attachment.cgi?id=354953
>

Could you check what is the polling period of the device.
something like:
cat /sys/devices/platform/lis3lv02d/input/input9/poll

it is current polling period in milliseconds. 0 disables polling.

-Samu

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
