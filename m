Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2KERHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:07:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45475 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2KERHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:07:09 -0500
Date: Mon, 5 Nov 2012 22:41:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/31] numa/core patches
Message-ID: <20121105171106.GA25353@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121025121617.617683848@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121025121617.617683848@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110517-9360-0000-0000-00000C7024C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Peter, 


Here are results on 2node and 8node machine while running the autonuma
benchmark.
----------------------------------------------------------------------------
On 2 node, 12 core 24GB 
----------------------------------------------------------------------------
KernelVersion: 3.7.0-rc3
                        Testcase:      Min      Max      Avg
                          numa01:   121.23   122.43   121.53
                numa01_HARD_BIND:    80.90    81.07    80.96
             numa01_INVERSE_BIND:   145.91   146.06   145.97
             numa01_THREAD_ALLOC:   395.81   398.30   397.47
   numa01_THREAD_ALLOC_HARD_BIND:   264.09   264.27   264.18
numa01_THREAD_ALLOC_INVERSE_BIND:   476.36   476.65   476.53
                          numa02:    53.11    53.19    53.15
                numa02_HARD_BIND:    35.20    35.29    35.25
             numa02_INVERSE_BIND:    63.52    63.55    63.54
                      numa02_SMT:    60.28    62.00    61.33
            numa02_SMT_HARD_BIND:    42.63    43.61    43.22
         numa02_SMT_INVERSE_BIND:    76.27    78.06    77.31

KernelVersion: numasched (i.e 3.7.0-rc3 + your patches)
                        Testcase:      Min      Max      Avg  %Change
                          numa01:   121.28   121.71   121.47    0.05%
                numa01_HARD_BIND:    80.89    81.01    80.96    0.00%
             numa01_INVERSE_BIND:   145.87   146.04   145.96    0.01%
             numa01_THREAD_ALLOC:   398.07   400.27   398.90   -0.36%
   numa01_THREAD_ALLOC_HARD_BIND:   264.02   264.21   264.14    0.02%
numa01_THREAD_ALLOC_INVERSE_BIND:   476.13   476.62   476.41    0.03%
                          numa02:    52.97    53.25    53.13    0.04%
                numa02_HARD_BIND:    35.21    35.28    35.24    0.03%
             numa02_INVERSE_BIND:    63.51    63.54    63.53    0.02%
                      numa02_SMT:    61.35    62.46    61.97   -1.03%
            numa02_SMT_HARD_BIND:    42.89    43.85    43.22    0.00%
         numa02_SMT_INVERSE_BIND:    76.53    77.68    77.08    0.30%

----------------------------------------------------------------------------

KernelVersion: 3.7.0-rc3(with HT enabled )
                        Testcase:      Min      Max      Avg
                          numa01:   242.58   244.39   243.68
                numa01_HARD_BIND:   169.36   169.40   169.38
             numa01_INVERSE_BIND:   299.69   299.73   299.71
             numa01_THREAD_ALLOC:   399.86   404.10   401.50
   numa01_THREAD_ALLOC_HARD_BIND:   278.72   278.77   278.75
numa01_THREAD_ALLOC_INVERSE_BIND:   493.46   493.59   493.54
                          numa02:    53.00    53.33    53.19
                numa02_HARD_BIND:    36.77    36.88    36.82
             numa02_INVERSE_BIND:    66.07    66.10    66.09
                      numa02_SMT:    53.23    53.51    53.35
            numa02_SMT_HARD_BIND:    35.19    35.27    35.24
         numa02_SMT_INVERSE_BIND:    63.50    63.54    63.52

KernelVersion: numasched (i.e 3.7.0-rc3 + your patches) (with HT enabled)
                        Testcase:      Min      Max      Avg  %Change
                          numa01:   242.68   244.59   243.53    0.06%
                numa01_HARD_BIND:   169.37   169.42   169.40   -0.01%
             numa01_INVERSE_BIND:   299.83   299.96   299.91   -0.07%
             numa01_THREAD_ALLOC:   399.53   403.13   401.62   -0.03%
   numa01_THREAD_ALLOC_HARD_BIND:   278.78   278.80   278.79   -0.01%
numa01_THREAD_ALLOC_INVERSE_BIND:   493.63   493.90   493.78   -0.05%
                          numa02:    53.06    53.42    53.22   -0.06%
                numa02_HARD_BIND:    36.78    36.87    36.82    0.00%
             numa02_INVERSE_BIND:    66.09    66.10    66.10   -0.02%
                      numa02_SMT:    53.34    53.55    53.42   -0.13%
            numa02_SMT_HARD_BIND:    35.22    35.29    35.25   -0.03%
         numa02_SMT_INVERSE_BIND:    63.50    63.58    63.53   -0.02%
----------------------------------------------------------------------------



On 8 node, 64 core, 320 GB 
----------------------------------------------------------------------------

KernelVersion: 3.7.0-rc3()
                        Testcase:      Min      Max      Avg
                          numa01:  1550.56  1596.03  1574.24
                numa01_HARD_BIND:   915.25  2540.64  1392.42
             numa01_INVERSE_BIND:  2964.66  3716.33  3149.10
             numa01_THREAD_ALLOC:   922.99  1003.31   972.99
   numa01_THREAD_ALLOC_HARD_BIND:   579.54  1266.65   896.75
numa01_THREAD_ALLOC_INVERSE_BIND:  1794.51  2057.16  1922.86
                          numa02:   126.22   133.01   130.91
                numa02_HARD_BIND:    25.85    26.25    26.06
             numa02_INVERSE_BIND:   341.38   350.35   345.82
                      numa02_SMT:   153.06   175.41   163.47
            numa02_SMT_HARD_BIND:    27.10   212.39   114.37
         numa02_SMT_INVERSE_BIND:   285.70  1542.83   540.62

KernelVersion: numasched()
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  1542.69  1601.81  1569.68    0.29%
                numa01_HARD_BIND:   867.35  1094.00   966.05   44.14%
             numa01_INVERSE_BIND:  2835.71  3030.36  2966.99    6.14%
             numa01_THREAD_ALLOC:   326.35   379.43   347.01  180.39%
   numa01_THREAD_ALLOC_HARD_BIND:   611.55   720.09   657.06   36.48%
numa01_THREAD_ALLOC_INVERSE_BIND:  1839.60  1999.58  1919.36    0.18%
                          numa02:    35.35    55.09    40.81  220.78%
                numa02_HARD_BIND:    26.58    26.81    26.68   -2.32%
             numa02_INVERSE_BIND:   341.86   355.36   347.68   -0.53%
                      numa02_SMT:    37.65    48.65    43.08  279.46%
            numa02_SMT_HARD_BIND:    28.29   157.66    84.29   35.69%
         numa02_SMT_INVERSE_BIND:   313.07   346.72   333.69   62.01%
----------------------------------------------------------------------------

-- 
Thanks and Regards
Srikar

