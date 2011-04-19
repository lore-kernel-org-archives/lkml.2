Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1DSFGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:06:21 -0400
Received: from science.horizon.com ([71.41.210.146]:62553 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751692Ab1DSFGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:06:19 -0400
Date: 19 Apr 2011 01:06:18 -0400
Message-ID: <20110419050618.18187.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: luto@mit.edu
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not doing so well:

$ ./evil-clock-test
CPU vendor   : AuthenticAMD
CPU model    : AMD Phenom(tm) 9850 Quad-Core Processor
CPU stepping : 3
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using mfence_rdtsc because you don't have an Intel CPU
Will test the "mfence;rdtsc" clock.
Now test passed  : margin 168 with 15744696 samples
Load3 test got no data
Load test got no data
Store test failed: worst error 10 with 617583 samples

$ ./evil-clock-test
CPU vendor   : AuthenticAMD
CPU model    : AMD Phenom(tm) 9850 Quad-Core Processor
CPU stepping : 3
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using mfence_rdtsc because you don't have an Intel CPU
Will test the "mfence;rdtsc" clock.
Now test passed  : margin 168 with 15666016 samples
Load3 test got no data
Load test got no data
Store test got no data

$ ./evil-clock-test
CPU vendor   : AuthenticAMD
CPU model    : AMD Phenom(tm) 9850 Quad-Core Processor
CPU stepping : 3
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using mfence_rdtsc because you don't have an Intel CPU
Will test the "mfence;rdtsc" clock.
Now test passed  : margin 168 with 15981720 samples
Load3 test got no data
Load test got no data
Store test got no data

Compiled from git revision 8f7d7a62, "Add script to test all pairs."
Running as root makes no difference.

Other programs:

$ ./now_test_all_pairs.sh
0,1: Now test passed  : margin 168 with 15007304 samples
0,2: Now test passed  : margin 168 with 15288360 samples
0,3: Now test passed  : margin 168 with 15539776 samples
1,0: Now test passed  : margin 168 with 14890744 samples
1,2: Now test passed  : margin 168 with 15266128 samples
1,3: Now test passed  : margin 168 with 15322480 samples
2,0: Now test passed  : margin 168 with 14978320 samples
2,1: Now test passed  : margin 168 with 15109872 samples
2,3: Now test passed  : margin 168 with 15207616 samples
3,0: Now test passed  : margin 168 with 15043208 samples
3,1: Now test passed  : margin 168 with 14686352 samples
3,2: Now test passed  : margin 168 with 14945840 samples

$ ./timing_test
Usage: time <Miters> <mode> [POSIX clock id]

Clocks are:
  0 (CLOCK_REALTIME)  resolution = 0.000000001
  1 (CLOCK_MONOTONIC)  resolution = 0.000000001
  5 (CLOCK_REALTIME_COARSE)  resolution = 0.010000000
  6 (CLOCK_MONOTONIC_COARSE)  resolution = 0.010000000

System is 2.6.38.2 with 8 GB ECC RAM.  ATI RD790/SB600 chipset.

Hope this helps!
