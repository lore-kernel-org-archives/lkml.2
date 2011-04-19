Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1DSAtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:49:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49110 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1DSAtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=tCi3bx+IlPKU0r5Fh7QAea1+ojPmB8ZuuQlZoLp4ltHqAJzQuW/6DrHLKNe1wT8u7G
         E+aqQP+fPAZwL7BKnitVFMcaWOGe6zfYxe3XXyyyFPGacLT9HUU/SU+aZhUc8hRLAWVd
         /+4kV9mzdIvvkDwKlaZfGWawMqz/r5GR5oRWg=
Date: Tue, 19 Apr 2011 03:49:00 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app
 included)
Message-ID: <20110419034900.6bd6484c@mdontu-dell.dsd.ro>
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Organization: Home
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:32:52 -0400 Andrew Lutomirski <luto@mit.edu> wrote:
> Hi all-
> 
> I'd appreciate some help testing rdtsc's ordering wrt memory on
> various hardware.  You can download evil-clock-test code at:
> 
> https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/raw/master/evil-clock-test.cc

On my laptop:
$ dmesg | grep -i tsc
[    0.000000] Fast TSC calibration using PIT
[    0.099991] TSC synchronization [CPU#0 -> CPU#1]:
[    0.099991] Measured 3156958390 cycles TSC warp between CPUs, turning off TSC clock.
[    0.099991] Marking TSC unstable due to check_tsc_sync_source failed

$ ./a.out
CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
CPU stepping : 6
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 200 with 17193024 samples
Load3 test passed: margin 23270 with 45 samples
Load test passed : margin 70 with 3704403 samples
Store test failed as expected: worst error 50 with 3535212 samples

On a colleague's laptop:
$ dmesg | grep -i tsc
[    0.000000] Fast TSC calibration using PIT
[    0.339747] Marking TSC unstable due to TSC halts in idle

$ ./a.out 
CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
CPU stepping : 6
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 87 with 44323872 samples
Load3 test passed: margin 32062 with 28 samples
Load test passed : margin 62 with 14113177 samples
Store test failed as expected: worst error 850 with 12444429 samples

One of the servers I have around (2 x 6 core + HT):
$ dmesg | grep -i tsc
[    0.000000] Fast TSC calibration using PIT
[    0.398130] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.577634] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.757168] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.936733] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    1.116321] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    1.295821] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    1.475418] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    1.654917] checking TSC synchronization [CPU#0 -> CPU#8]: passed.
[    1.834550] checking TSC synchronization [CPU#0 -> CPU#9]: passed.
[    2.014061] checking TSC synchronization [CPU#0 -> CPU#10]: passed.
[    2.193601] checking TSC synchronization [CPU#0 -> CPU#11]: passed.
[    2.373170] checking TSC synchronization [CPU#0 -> CPU#12]: passed.
[    2.552713] checking TSC synchronization [CPU#0 -> CPU#13]: passed.
[    2.732212] checking TSC synchronization [CPU#0 -> CPU#14]: passed.
[    2.911760] checking TSC synchronization [CPU#0 -> CPU#15]: passed.
[    3.091288] checking TSC synchronization [CPU#0 -> CPU#16]: passed.
[    3.270920] checking TSC synchronization [CPU#0 -> CPU#17]: passed.
[    3.450454] checking TSC synchronization [CPU#0 -> CPU#18]: passed.
[    3.629995] checking TSC synchronization [CPU#0 -> CPU#19]: passed.
[    3.809492] checking TSC synchronization [CPU#0 -> CPU#20]: passed.
[    3.989045] checking TSC synchronization [CPU#0 -> CPU#21]: passed.
[    4.168647] checking TSC synchronization [CPU#0 -> CPU#22]: passed.
[    4.348183] checking TSC synchronization [CPU#0 -> CPU#23]: passed.
[    4.577658] Switching to clocksource tsc

$ ./a.out
CPU vendor   : GenuineIntel
CPU model    : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
CPU stepping : 2
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 233 with 32792352 samples
Load3 test passed: margin 193 with 1912536 samples
Load test passed : margin 85 with 4347111 samples
Store test failed as expected: worst error 1996 with 3920055 samples

-- 
Mihai Donțu
