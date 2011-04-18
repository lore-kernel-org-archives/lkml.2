Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1DRU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:28:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47839 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1DRU2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Xr1cjFP2IAJ0iWVp78z8GlE1yd93dsqtiCfgBgDPRSwM2/Sxva8zm/KBAYZh/NY+7C
         QY7XPypGXJii2UhC2zKAvZasCFbee2L2/o9XaswhH5M0e0WQ10GuYQwbj+XcNduIVQqj
         CMhpjcgDFYXFulHshx4OArQPMIit4YDcjURL8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UjQ5tenjbHpkNWGmFSd2JzOvOOw@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com> <BANLkTi=UjQ5tenjbHpkNWGmFSd2JzOvOOw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 18 Apr 2011 16:27:57 -0400
X-Google-Sender-Auth: tOJ8PN7uC6A5deiNo84q2CVHlhA
Message-ID: <BANLkTikEAro9mbrPys+iqUEJDvGFmRvwsA@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
To: Colin Walters <walters@verbum.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 4:23 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, Apr 18, 2011 at 3:32 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> Hi all-
>>
>> I'd appreciate some help testing rdtsc's ordering wrt memory on
>> various hardware.  You can download evil-clock-test code at:
>>
>> https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/raw/master/evil-clock-test.cc
>
> Hmm...the first time I ran it, it started OK, then printed over and over:
>
>  ERROR!  Time1 went back by 2380216472
>  ERROR!  Time1 went back by 2380216080
>  ERROR!  Time1 went back by 2380215704
>  ERROR!  Time1 went back by 2380215320

Well, crap.  Can you run:
 dmesg | grep -i tsc

There are two possible explanations:
1. Your tscs are out of sync, and whether the test notices or not
depends on which cpus the scheduler sticks the threads on.
2. I have a dumb bug that makes it malfunction.  I used to have some
of those but I thought I fixed them.

Thanks,
Andy

>
> and the original output was lost in the terminal emulator history.
> After piping it to tee a second time, of course it worked and didn't
> print any errors =)
>
> CPU vendor   : GenuineIntel
> CPU model    : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
> CPU stepping : 10
> TSC flags    : tsc constant_tsc
> Using lfence_rdtsc because you have an Intel CPU
> Will test the "lfence;rdtsc" clock.
> Now test passed  : margin 160 with 28911200 samples
> Load3 test passed: margin 144 with 2493322 samples
> Load test passed : margin 120 with 4929138 samples
> Store test failed as expected: worst error 2184 with 4409828 samples
>
> What's interesting is it seems unpredictable when running it whether
> it will error out =/ Here's the start of a failing trace:
>
> CPU vendor   : GenuineIntel
> CPU model    : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
> CPU stepping : 10
> TSC flags    : tsc constant_tsc
> Using lfence_rdtsc because you have an Intel CPU
> Will test the "lfence;rdtsc" clock.
> Now test failed  : worst error 2399269920 with 28704328 samples
>  ERROR!  Time1 went back by 2399197568
>  ERROR!  Time1 went back by 2399196984
>
