Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1DRUXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:23:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59872 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1DRUXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m9xeAVFH0bZfph8PYOGFGizVooc/+wgatBIqjUUMyCflw5GQr3qnILr5Kllx56v22I
         ZyGzjA0gxSY79PoWvEPnfmlyj129dqG0ZlK1/DKNKRv2H+r+VGqL2HPZTln3/WBDeG4J
         lW02t9xakn1tPZPQHZ4GPF2EfxWF66Vo73CEY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Date: Mon, 18 Apr 2011 16:23:45 -0400
X-Google-Sender-Auth: otjJl2FnejxNprLp0cAeYIps_0g
Message-ID: <BANLkTi=UjQ5tenjbHpkNWGmFSd2JzOvOOw@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
From: Colin Walters <walters@verbum.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 3:32 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> Hi all-
>
> I'd appreciate some help testing rdtsc's ordering wrt memory on
> various hardware.  You can download evil-clock-test code at:
>
> https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/raw/master/evil-clock-test.cc

Hmm...the first time I ran it, it started OK, then printed over and over:

  ERROR!  Time1 went back by 2380216472
  ERROR!  Time1 went back by 2380216080
  ERROR!  Time1 went back by 2380215704
  ERROR!  Time1 went back by 2380215320

and the original output was lost in the terminal emulator history.
After piping it to tee a second time, of course it worked and didn't
print any errors =)

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
CPU stepping : 10
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 160 with 28911200 samples
Load3 test passed: margin 144 with 2493322 samples
Load test passed : margin 120 with 4929138 samples
Store test failed as expected: worst error 2184 with 4409828 samples

What's interesting is it seems unpredictable when running it whether
it will error out =/ Here's the start of a failing trace:

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
CPU stepping : 10
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test failed  : worst error 2399269920 with 28704328 samples
  ERROR!  Time1 went back by 2399197568
  ERROR!  Time1 went back by 2399196984
