Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KJU4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:56:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62015 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0KJU4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VXmvz2rTrtHNaNR2lOuQotP0gNzRpIFuXAl55eXKNf9GCTSHxwfaws9tqUUhSCXrEm
         4/Pc69RzUp/R3Kl+u6ZGvnGoFii32WWvjnU+RoJGaOuw26naLzdRyidO2Elk898dKqAg
         urRckKmdEvTORrnm1iOWX9fa0R2n0SoVJySKk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011102147580.2900@localhost6.localdomain6>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de> <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
 <20101109180123.GB31121@aftab> <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
 <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com>
 <20101110185031.GB13539@aftab> <AANLkTimNuSJz0nXZCR2zu963VQ_Y9R8ix73+QbbUy7nt@mail.gmail.com>
 <alpine.LFD.2.00.1011102147580.2900@localhost6.localdomain6>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 15:56:10 -0500
X-Google-Sender-Auth: egcH1VUlIUN5d3Ty1_sRPGmF_SI
Message-ID: <AANLkTimP1F=GsnEqp-koTdy4jfaxzKpetC3Suo1Yidcm@mail.gmail.com>
Subject: Re: [FALSE ALARM] Re: HPET (?) related hangs and breakage in 2.6.35,36
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@amd64.org>, Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 3:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 10 Nov 2010, Andrew Lutomirski wrote:
>
>> On Wed, Nov 10, 2010 at 1:50 PM, Borislav Petkov <bp@amd64.org> wrote:
>> > On Wed, Nov 10, 2010 at 01:48:00PM -0500, Andrew Lutomirski wrote:
>> >> > Clocksource: tsc unstable (delta = -34355296774 ns)
>> >> > Switching: to clocksource hpet
>> >>
>> >> Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
>> >> send a bug report to the maintainers.
>> >
>> > Interesting! Joerg was complaining about similar symptoms with .36 today
>> > too.
>>
>> Well, there is a clocksource sort-of-bug that could cause confusion:
>> when something totally unrelated to clocksources goes out to lunch,
>> the clocksource watchdog decides that the clocksource is unstable and
>> complains, steering everyone toward filing the wrong bug.
>
> How should the clocksource watchdog code know that something went to
> lunch? The fact that we need to monitor TSC at all is horrible enough,
> adding further heuristics to detect extended lunch breaks would be
> just a PITA.

Could the clocksource watchdog detect when it gets woken up (i.e. when
the hardware timer fires) instead of when it gets scheduled?  It is
internal to the timing code, after all...

Alternatively, maybe the watchdog could just compare the TSC timestamp
to the current value according to some other clock (PIT?  whatever
clockevent is in use?) instead of just using the time passed into the
delayed work in the first place.

>
> Maybe we could print a different warning when we see large negative
> deltas, which is the main indicator for the system being stuck for
> quite a time while TSC advances happily.

That would be an easy fix.

--Andy
