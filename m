Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1DRUQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:16:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1DRUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 13:16:11 -0700
Message-ID: <BANLkTi=hpNy3iA+49N90dbU4f0_L2RVJNQ@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 12:32 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> I've tested on Sandy Bridge, Allendale (i.e. Pentium Dual-Core),
> Bloomfield. and C2D.

Arrandale:

  CPU vendor   : GenuineIntel
  CPU model    : Intel(R) Core(TM) i5 CPU         670  @ 3.47GHz
  CPU stepping : 2
  TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
  Using lfence_rdtsc because you have an Intel CPU
  Will test the "lfence;rdtsc" clock.
  Now test passed  : margin 98 with 71696816 samples
  Load3 test passed: margin 72 with 8926478 samples
  Load test passed : margin 88 with 14660759 samples
  Store test failed as expected: worst error 764 with 10784245 samples

but that wasn't very surprising since you already tested the
micro-architectures just around it.

On a dual-socket X5550 (master.kernel.org: 16 threads total: 4 cores
per socket, with HT):

  CPU vendor   : GenuineIntel
  CPU model    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
  CPU stepping : 5
  TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
  Using lfence_rdtsc because you have an Intel CPU
  Will test the "lfence;rdtsc" clock.
  Now test passed  : margin 166 with 38875272 samples
  Load3 test passed: margin 235 with 2972261 samples
  Load test passed : margin 119 with 4409699 samples
  Store test failed as expected: worst error 2710 with 3764216 samples

Some opteron love would be good, but I don't have access to any right here.

                     Linus
