Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0KIRpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:45:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52651 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0KIRpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=BuVgS5hWLn9bGqs0Lflh4rnZlvB3yFAr06VOgLT0mmC7Jk2mSWvTP4AdttRYol7qo/
         +LpEIKduH8EiVe5INWGdpAgEIy0wGEmBNB5lpR0UZ90vmda5KdioBhgMXNUGWoh6OYKd
         Qjpif29qx2onnj3l1rhw/kFj3XUfVLUNKvfUo=
MIME-Version: 1.0
In-Reply-To: <20101109153805.GB3146@kryptos.osrc.amd.com>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de> <20101109153805.GB3146@kryptos.osrc.amd.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Nov 2010 12:44:48 -0500
X-Google-Sender-Auth: E0pMKDZO9O3cX2pE6gDKwjg8f5s
Message-ID: <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
Subject: Re: HPET (?) related hangs and breakage in 2.6.35,36
To: Borislav Petkov <bp@amd64.org>, Clemens Ladisch <clemens@ladisch.de>,
        Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 10:38 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Tue, Nov 09, 2010 at 04:20:56PM +0100, Clemens Ladisch wrote:
>> Andrew Lutomirski wrote:
>> > After several minutes of uptime, my system freezes in a strange way.
>> > All of userspace and some kernel services freeze hard (no mouse, no
>> > typing, etc.)  Caps-lock works intermittently, as does (I think)
>> > pinging.  The only debug output I've been able to get is this (typed
>> > from a blurry photo because netconsole dies along with everything
>> > else):
>> >
>> > [ 5478.244722] Clocksource tsc unstable (delta = 101399051316 ns)
>> > [ 5478.367958] Switching to clocksource hpet
>> > [ 5543.729698] BUG: soft lockup - CPU #1 stuck for 61s! [migration/1:6]
>>
>> Looks like this one:
>> http://lkml.org/lkml/2010/10/26/126
>
> I don't think so: the one at the URL above is 37-rc1 specific (issue
> came in during the merge window) while Andrew's problem can be
> reproduced with 35 and 36, reportedly.
>
> Anyway, adding more people to Cc.

I may have just reproduced after a couple of days of uptime it in
2.6.36 with hpet=disable (in any case, the system hung and netconsole
didn't work).

I'm currently testing the hpet_min_tick stuff, backported to 2.6.36,
with hpet on.  Haven't had a problem yet, but I'll see what happens
after a few hours.  So far, it said:

ACPI: HPET id: 0x8086a301 base: 0xfed00000 min tick: 128

Is there any way that a tsc delta of >100 seconds occurring awhile
after bootup on Nehalem with a single socket can real (as opposed to a
bug making the kernel think that there was a delta when there really
wasn't)?

--Andy

>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
>
>
