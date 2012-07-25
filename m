Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2GYL4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:56:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40949 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2GYL4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:56:00 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <201207251257.50064.maciej.rutecki@gmail.com>
References: <201207251020.47637.maciej.rutecki@gmail.com>
	<201207251054.25498.maciej.rutecki@gmail.com>
	<20120725092928.GD5396@phenom.ffwll.local>
	<201207251257.50064.maciej.rutecki@gmail.com>
Date: Wed, 25 Jul 2012 13:55:59 +0200
X-Google-Sender-Auth: YGVay1uAKWVdzbfXt_rt6kYRXvg
Message-ID: <CAKMK7uEZ+TYziN9tNDUc-UVeAzvVuivA869uwQYiWGoAKEq1jg@mail.gmail.com>
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and XWindow
From: Daniel Vetter <daniel@ffwll.ch>
To: maciej.rutecki@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 12:57 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> On środa, 25 lipca 2012 o 11:29:28 Daniel Vetter wrote:
>> On Wed, Jul 25, 2012 at 10:54:25AM +0200, Maciej Rutecki wrote:
>> > On środa, 25 lipca 2012 o 10:29:26 Daniel Vetter wrote:
>> > > On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
>> > > > Last known good: 3.4.4
>> > > > First bad: 3.5.0
>> > > >
>> > > > When booting 3.5.0 resolution (in console, and after in KDE) is set
>> > > > to 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).
>> > >
>> > > Can you please attach the output of xrandr --verbose for both kernels?
>> > > Also, please boot with drm.debug=0xe added to your kernel cmdline and
>> > > grab the dmesg (again for both kernels).
>> >
>> > Thanks for the ansfer.
>> >
>> > Here xrandr and dmesg outputs for 3.4.4 and 3.5.0
>> >
>> > http://mrutecki.pl/download/kernel/3.5/swinka/debug/
>>
>> Can you please test this quick hack:
>>
>>
>> diff --git a/drivers/gpu/drm/i915/intel_i2c.c
>> b/drivers/gpu/drm/i915/intel_i2c.c index 1991a44..abe1611 100644
>> --- a/drivers/gpu/drm/i915/intel_i2c.c
>> +++ b/drivers/gpu/drm/i915/intel_i2c.c
>> @@ -405,7 +405,7 @@ clear_err:
>>        * timing out seems to happen when there _is_ a ddc chip present, but
>>        * it's slow responding and only answers on the 2nd retry.
>>        */
>> -     ret = -ENXIO;
>> +     ret = 0;
>>       if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
>>                    10)) {
>>               DRM_DEBUG_KMS("GMBUS [%s] timed out after NAK\n",
>>
>>
>> Thanks, Daniel
>
> Still the same.

Hm, can you attach the dmesg again (with drm.debug=0xe)? If I haven't
botched up something, we should now retry at least the ddc transfer
...
-Daniel

>
> PS. Unfortunately, this afternoon I have small a surgical operation and
> further tests will be possible only after 2-3 days.
>
> Regards
> --
> Maciej Rutecki
> http://www.mrutecki.pl



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
