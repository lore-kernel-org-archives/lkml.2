Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1DRWK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:10:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35734 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1DRWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:10:54 -0400
Date: Tue, 19 Apr 2011 00:10:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Message-ID: <20110418221051.GR16484@one.firstfloor.org>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested it on a dual Westmere-EP and a Quad Westmere-EX.
Seems to pass everywhere.

However I kept the default MAX_THREADS 4. Shouldn't that be 
increased for the large systems?

I suspect the tests as written didn't really use the large 
systems.

Dual:

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Xeon(R) CPU           E5640  ...
CPU stepping : ..
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test failed  : worst error 48 with 48647928 samples
Load3 test passed: margin 368 with 1013805 samples
Load test passed : margin 368 with 4142659 samples
Store test failed as expected: worst error 2940 with 4298473 samples

Quad:

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Xeon(R) CPU E7 ...
CPU stepping : ..
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 208 with 11997136 samples
Load3 test passed: margin 812 with 98710 samples
Load test passed : margin 208 with 1259451 samples
Store test failed as expected: worst error 9284 with 1086616 samples


-Andi
