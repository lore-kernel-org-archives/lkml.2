Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab0DPMN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:13:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15025 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab0DPMNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:13:25 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: samu.p.onkalo@nokia.com, jkosina@suse.cz, eric.piel@tremplin-utc.net
Cc: akpm@linux-foundation.org, pavel@ucw.cz, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input
 interface
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
 <4BBF2BD1.5050107@tremplin-utc.net>
 <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
 <op.va86rulwgp7y00@linux-r26l.site>
 <62697B07E9803846BC582181BD6FB6B826A8525E8A@NOK-EUMSG-02.mgdnok.nokia.com>
Date: Fri, 16 Apr 2010 14:13:21 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Marcin Derlukiewicz" <marcin@derlukiewicz.pl>
Message-ID: <op.va878jw6gp7y00@linux-r26l.site>
In-Reply-To: <62697B07E9803846BC582181BD6FB6B826A8525E8A@NOK-EUMSG-02.mgdnok.nokia.com>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 16-04-2010 o 14:00:15 <samu.p.onkalo@nokia.com> napisał(a):

>
>
>> -----Original Message-----
>> From: ext Marcin Derlukiewicz [mailto:marcin@derlukiewicz.pl]
>> Sent: 16 April, 2010 14:42
>> To: Jiri Kosina; Éric Piel
>> Cc: Andrew Morton; Onkalo Samu.P (Nokia-D/Tampere); Pavel Machek; lm-
>> sensors@lm-sensors.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input
>> interface
>>
>> Dnia 09-04-2010 o 15:32:59 Jiri Kosina <jkosina@suse.cz> napisał(a):
>>
>>> On Fri, 9 Apr 2010, Éric Piel wrote:
>>>
>>>> > This is reported to create 20% CPU usage increase (and
>> proportionaly
>>>> higher
>>>> > power consumption) just for the ipolldevd kernel thread (which is
>> used
>>>> > to read the sensor).
>>>> >
>>>> > As most users probably only use the freefall functionality of the
>>>> driver
>>>> > and not the joystick interface, provide means for disabling the
>>>> registration
>>>> > of joystick device altogether via module parameter.
>>>> > (I'd rather make it default to 0, but this will break backwards
>>>> compatibility).
>>>> Are you saying there is a 20% CPU usage even when the joystick
>> interface
>>>> is not open? This should not happen (and this is not happening on my
>>>> laptop). The polling should happen only when a userspace app opens
>> the
>>>> joystick interface (like running neverball).
>>>>
>>>> So I'd tend to think it's more due to a misconfiguration of the
>> system
>>>> (like xserver using the joystick interface as a pointer device) or
>> it's
>>>> a bug in the way we set up the polling. Could you investigate and let
>> me
>>>> know?
>>>
>>> Marcin originally reported this to me.
>>>
>>> Marcin, could you please check 'lsof' output to see whether the
>> joystick
>>> interface has been open by some application?
>>>
>>> Thanks,
>>>
>>
>> sorry for the delay, had a crunch time
>>
>> here is the link for this lsof:
>> https://bugzilla.novell.com/attachment.cgi?id=354953
>>
>
> Could you check what is the polling period of the device.
> something like:
> cat /sys/devices/platform/lis3lv02d/input/input9/poll
>
> it is current polling period in milliseconds. 0 disables polling.
>
> -Samu
>

I think that on my system this is /sys/devices/platform/lis3lv02d/rate
but i may be wrong. Anyway it contains 40 as a number.

Marcin.
