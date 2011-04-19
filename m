Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1DSILG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:11:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:51604 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1DSILD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:11:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Date: Tue, 19 Apr 2011 09:10:38 +0100
Message-ID: <4DAD437E.6090302@kingswood-consulting.co.uk>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
X-Gmane-NNTP-Posting-Host: 193.122.140.26
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/11 20:32, Andrew Lutomirski wrote:
> Hi all-
>
> I'd appreciate some help testing rdtsc's ordering wrt memory on
> various hardware.  You can download evil-clock-test code at:
>
> https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/raw/master/evil-clock-test.cc

A low power core2 server:

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz
CPU stepping : 6
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 84 with 39213496 samples
Load3 test passed: margin 20947164 with 15 samples
Load test passed : margin 52 with 12466437 samples
Store test failed as expected: worst error 1397 with 11151528 samples

That margin number seemed a bit high, rerunning gives:

CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz
CPU stepping : 6
TSC flags    : tsc constant_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 84 with 39201440 samples
Load3 test passed: margin 7991 with 15 samples
Load test passed : margin 52 with 12482714 samples
Store test failed as expected: worst error 2457 with 11129294 samples

Frank

