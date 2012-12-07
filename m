Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab2LGLPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:15:54 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55386 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab2LGLPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:15:52 -0500
Date: Fri, 7 Dec 2012 16:15:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] Automatic NUMA Balancing V7
Message-ID: <20121207104539.GB22164@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
 <20121126145800.GK8218@suse.de>
 <20121128134930.GB20087@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121128134930.GB20087@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120711-9360-0000-0000-00000DA5F7DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got a chance to run autonuma-benchmark on a 8 node, 64 core machine. 
the results are as below. (for each kernel I ran 5 iterations of
autonuma-benchmark)

KernelVersion: 3.7.0-rc3-mainline_v37rc7()
                        Testcase:      Min      Max      Avg
                          numa01:  1562.65  1621.02  1595.92
                numa01_HARD_BIND:   916.84  1114.15  1031.68
             numa01_INVERSE_BIND:  2841.51  7864.06  4145.55
             numa01_THREAD_ALLOC:  1014.28  1722.63  1233.83
   numa01_THREAD_ALLOC_HARD_BIND:   595.15   683.74   645.45
numa01_THREAD_ALLOC_INVERSE_BIND:  1987.64  3324.27  2431.64
                          numa02:   126.07   147.53   132.66
                numa02_HARD_BIND:    25.82    26.54    26.16
             numa02_INVERSE_BIND:   339.12   352.30   344.61
                      numa02_SMT:   137.85   369.20   202.97
            numa02_SMT_HARD_BIND:    27.11   151.72    84.33
         numa02_SMT_INVERSE_BIND:   287.53  1510.83   535.73

KernelVersion: 3.6.0-autonuma+()
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  2102.39  2283.92  2211.19  -27.83%
                numa01_HARD_BIND:   929.84  1155.89  1054.46   -2.16%
             numa01_INVERSE_BIND:  2959.99  4309.97  3366.57   23.14%
             numa01_THREAD_ALLOC:   354.59   453.28   381.67  223.27%
   numa01_THREAD_ALLOC_HARD_BIND:   580.08  1041.88   749.49  -13.88%
numa01_THREAD_ALLOC_INVERSE_BIND:  1805.52  2186.07  1990.85   22.14%
                          numa02:    50.06    62.44    58.25  127.74%
                numa02_HARD_BIND:    25.85    26.26    26.03    0.50%
             numa02_INVERSE_BIND:   335.19   378.02   345.20   -0.17%
                      numa02_SMT:    56.73    71.73    63.67  218.78%
            numa02_SMT_HARD_BIND:    35.70    75.05    50.52   66.92%
         numa02_SMT_INVERSE_BIND:   292.38   302.87   297.85   79.87%

KernelVersion: 3.7.0-rc6-mel_auto_balance+ (mm-balancenuma-v7r6)
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  1606.26  1815.21  1703.47   -6.31%
                numa01_HARD_BIND:   952.50  1186.68  1072.18   -3.78%
             numa01_INVERSE_BIND:  2851.68  5238.50  3417.63   21.30%
             numa01_THREAD_ALLOC:  1013.36  2675.91  1681.84  -26.64%
   numa01_THREAD_ALLOC_HARD_BIND:   660.48  1310.79  1007.33  -35.92%
numa01_THREAD_ALLOC_INVERSE_BIND:  1858.45  2567.01  2053.79   18.40%
                          numa02:   127.00   387.29   181.77  -27.02%
                numa02_HARD_BIND:    25.58    26.30    26.07    0.35%
             numa02_INVERSE_BIND:   342.17   448.23   367.59   -6.25%
                      numa02_SMT:   150.28   739.28   313.60  -35.28%
            numa02_SMT_HARD_BIND:    27.46   234.01   109.82  -23.21%
         numa02_SMT_INVERSE_BIND:   289.47   500.87   339.96   57.59%

KernelVersion: 3.7.0-rc5-tip_master+ (Nov 23rd tip) 
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  1294.35  1760.17  1555.51    2.60%
                numa01_HARD_BIND:   769.32  2588.15  1429.87  -27.85%
             numa01_INVERSE_BIND:  3003.87  4041.55  3335.73   24.28%
             numa01_THREAD_ALLOC:   308.77   341.92   321.26  284.06%
   numa01_THREAD_ALLOC_HARD_BIND:   484.54   547.84   516.80   24.89%
numa01_THREAD_ALLOC_INVERSE_BIND:  1873.33  2026.21  1978.36   22.91%
                          numa02:    34.73    38.61    36.62  262.26%
                numa02_HARD_BIND:    29.08    31.07    29.66  -11.80%
             numa02_INVERSE_BIND:    30.72    34.16    31.60  990.54%
                      numa02_SMT:    36.05    43.49    40.35  403.02%
            numa02_SMT_HARD_BIND:    43.26   100.50    67.12   25.64%
         numa02_SMT_INVERSE_BIND:    44.33   114.72    75.12  613.17%

