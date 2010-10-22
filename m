Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0JVVIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:08:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58571 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab0JVVIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GVpJwgfggBPMN8ud37+g03S5EuWbiiukdLHRFz/RFx1ex+mfeAE/HVRHfibUo2KGCe
         mQNcIz3rMxmkQij+37VoOIm7rCHAUsJcO1gavliIAsInjzBR3bAn9JK4uRXqZDZS+sw8
         92Yin1OPFi4YHTKI+Y06Sk3qhC2xSLnZKIzU4=
MIME-Version: 1.0
In-Reply-To: <20101022140044.d5b0e9ce.akpm@linux-foundation.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
 <20101021150250.f6499506.akpm@linux-foundation.org> <201010211823.38287.vapier@gentoo.org>
 <20101021155528.b3d6d027.akpm@linux-foundation.org> <AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
 <20101021162410.5c0d6720.akpm@linux-foundation.org> <AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
 <20101022133138.6d82f79a.akpm@linux-foundation.org> <AANLkTi=MRU3Qi6NQfqnCwX34sHL2Rx8AyaqRwrxNVQoM@mail.gmail.com>
 <20101022140044.d5b0e9ce.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 22 Oct 2010 17:07:52 -0400
X-Google-Sender-Auth: tWpg6JdCHRaMuPzKNbB1eH_Nukg
Message-ID: <AANLkTinTFcFHYv0KH7a=G11sZX8hWww8CvHYZ8xe9-3C@mail.gmail.com>
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 17:00, Andrew Morton wrote:
> On Fri, 22 Oct 2010 16:47:36 -0400 Mike Frysinger wrote:
>> On Fri, Oct 22, 2010 at 16:31, Andrew Morton wrote:
>> > On Fri, 22 Oct 2010 16:14:49 -0400 Mike Frysinger wrote:
>> >> On Thu, Oct 21, 2010 at 19:24, Andrew Morton wrote:
>> >> > On Thu, 21 Oct 2010 19:04:36 -0400 Mike Frysinger wrote:
>> >> >> you can say "lazy" all you like. __i dont see the point in going that route.
>> >> >
>> >> > Try
>> >> >
>> >> > __ __ __ __grep HAVE arch/x86/Kconfig
>> >> >
>> >> > If all of those were instead to use some random #define which the
>> >> > particular feature happened to define in some header file then we would
>> >> > have a mess on our hands.
>> >>
>> >> fun times. __new tact.
>> >>
>> >> Luca: your new atomic64_t test build fails on all arches that lack
>> >> atomic64_t. __please fix.
>> >
>> > That's only part of the problem. __The following won't build also:
>> >
>> > net/rds
>>
>> not true.  that code base is already using my suggestion:
>> net/rds/rds.h:
>> #ifdef ATOMIC64_INIT
>> #define KERNEL_HAS_ATOMIC64
>> #endif
>
> IOW, your suggestion led to a nasty local hack.  One which would be
> unneeded had we implemented this properly via Kconfig.

no.  mine was specific to the atomic64 api and not random consumers.
the test code is tightly coupled to the atomic64 api by nature, so my
proposal as constrained by the single instance makes perfect sense.
as soon as you start talking about more things needing to know "is
atomic64 available" and doing so at the config dependency level, then
a Kconfig option makes sense.  thus i didnt and still dont buy your
original argument against the original patch and constraint.  but with
real tree data, your suggestion makes sense.  perhaps i'll implement
it if i find time.
-mike
