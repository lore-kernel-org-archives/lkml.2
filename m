Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2GJKJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:09:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42050 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2GJKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:09:02 -0400
Message-ID: <4FFBFEC5.2050800@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 15:37:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Raghavendra <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
 : detailed result
References: <20120709062012.24030.37154.sendpatchset@codeblue> <1341870457.2909.27.camel@oc2024037011.ibm.com>
In-Reply-To: <1341870457.2909.27.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071000-7014-0000-0000-00000188F0A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 03:17 AM, Andrew Theurer wrote:
> On Mon, 2012-07-09 at 11:50 +0530, Raghavendra K T wrote:
>> Currently Pause Looop Exit (PLE) handler is doing directed yield to a
>> random VCPU on PL exit. Though we already have filtering while choosing
>> the candidate to yield_to, we can do better.
>
[...]
> Honestly, I not confident addressing this problem will improve the
> ebizzy score. That workload is so erratic for me, that I do not trust
> the results at all.  I have however seen consistent improvements in
> disabling PLE for a http guest workload and a very high IOPS guest
> workload, both with much time spent in host in the double runqueue lock
> for yield_to(), so that's why I still gravitate toward that issue.
>
Deatiled result
Base + Rik patch

ebizzy
=========

overcommit 1 x
1160 records/s
real 60.00 s
user  6.28 s
sys  1078.69 s
1130 records/s
real 60.00 s
user  5.15 s
sys  1080.51 s
1073 records/s
real 60.00 s
user  5.02 s
sys  1030.21 s
1151 records/s
real 60.00 s
user  5.51 s
sys  1097.63 s
1145 records/s
real 60.00 s
user  5.21 s
sys  1093.56 s
1149 records/s
real 60.00 s
user  5.32 s
sys  1097.30 s
1111 records/s
real 60.00 s
user  5.16 s
sys  1061.77 s
1115 records/s
real 60.00 s
user  5.16 s
sys  1066.99 s

overcommit 2 x
1818 records/s
real 60.00 s
user 11.67 s
sys  843.84 s
1809 records/s
real 60.00 s
user 11.77 s
sys  845.68 s
1865 records/s
real 60.00 s
user 11.94 s
sys  866.69 s
1822 records/s
real 60.00 s
user 12.81 s
sys  843.05 s
1928 records/s
real 60.00 s
user 14.02 s
sys  887.86 s
1915 records/s
real 60.00 s
user 11.55 s
sys  888.68 s
1997 records/s
real 60.00 s
user 11.34 s
sys  923.54 s
1985 records/s
real 60.00 s
user 11.41 s
sys  923.44 s

kernbench
===============
overcommit 1 x
Elapsed Time 49.2367 (33.6921)
User Time 243.313 (343.965)
System Time 385.21 (125.151)
Percent CPU 1243.33 (79.5257)
Context Switches 58450.7 (31603.6)
Sleeps 73987 (41782.5)
--
Elapsed Time 47.8367 (37.2156)
User Time 244.79 (349.112)
System Time 338.553 (141.732)
Percent CPU 1181 (81.074)
Context Switches 56194.3 (36421.6)
Sleeps 74355.3 (40263.5)
--
Elapsed Time 49.6067 (34.7325)
User Time 250.117 (354.008)
System Time 341.277 (57.5594)
Percent CPU 1197 (46.3573)
Context Switches 55520.3 (27748.1)
Sleeps 72673 (38997.4)
--
Elapsed Time 50.24 (36.6571)
User Time 247.873 (352.427)
System Time 349.11 (79.4226)
Percent CPU 1193.67 (50.362)
Context Switches 55153.3 (27926.2)
Sleeps 73128 (39532.4)

overcommit 2 x
Elapsed Time 91.9233 (96.6304)
User Time 278.347 (371.217)
System Time 222.447 (181.378)
Percent CPU 521.667 (46.1988)
Context Switches 49597 (35766.4)
Sleeps 77939.7 (36840.1)
--
Elapsed Time 89.48 (92.7224)
User Time 275.223 (364.737)
System Time 202.473 (172.233)
Percent CPU 497.333 (53.0031)
Context Switches 44117 (30001)
Sleeps 77196 (35746.2)
--
Elapsed Time 93.6133 (95.7924)
User Time 294.767 (379.39)
System Time 235.487 (207.567)
Percent CPU 529.667 (58.2866)
Context Switches 50588 (36669.4)
Sleeps 79323.7 (38285.8)
--
Elapsed Time 92.7267 (100.928)
User Time 286.537 (384.253)
System Time 232.983 (192.233)
Percent CPU 552 (76.961)
Context Switches 51071 (35090)
Sleeps 79059 (36466.4)

sysbench
==============
overcommit 1 x
     total time:                          12.1229s
     total number of events:              100041
     total time taken by event execution: 772.8819
--
     total time:                          12.0775s
     total number of events:              100013
     total time taken by event execution: 769.5969
--
     total time:                          12.1671s
     total number of events:              100011
     total time taken by event execution: 775.5967
--
     total time:                          12.2695s
     total number of events:              100003
     total time taken by event execution: 782.3780
--
     total time:                          12.1526s
     total number of events:              100014
     total time taken by event execution: 773.9802
--
     total time:                          12.3350s
     total number of events:              100069
     total time taken by event execution: 786.2091
--
     total time:                          12.1019s
     total number of events:              100013
     total time taken by event execution: 771.5163
--
     total time:                          12.0716s
     total number of events:              100010
     total time taken by event execution: 769.8809

overcommit 2 x
     total time:                          13.6532s
     total number of events:              100011
     total time taken by event execution: 870.0869
--
     total time:                          15.8572s
     total number of events:              100010
     total time taken by event execution: 910.6689
--
     total time:                          13.6100s
     total number of events:              100008
     total time taken by event execution: 867.1782
--
     total time:                          15.4295s
     total number of events:              100008
     total time taken by event execution: 917.8441
--
     total time:                          13.8994s
     total number of events:              100004
     total time taken by event execution: 885.6729
--
     total time:                          14.2006s
     total number of events:              100005
     total time taken by event execution: 887.0262
--
     total time:                          13.8869s
     total number of events:              100011
     total time taken by event execution: 885.3583
--
     total time:                          13.9183s
     total number of events:              100007
     total time taken by event execution: 880.4344

With Rik + PLE handler optimization patch
  ===========================================
ebizzy
==========
overcommit 1 x
2249 records/s
real 60.00 s
user  9.87 s
sys  1529.54 s
2316 records/s
real 60.00 s
user 10.51 s
sys  1550.33 s
2353 records/s
real 60.00 s
user 10.82 s
sys  1565.10 s
2365 records/s
real 60.00 s
user 10.88 s
sys  1569.00 s
2282 records/s
real 60.00 s
user 10.77 s
sys  1540.03 s
2292 records/s
real 60.00 s
user 10.60 s
sys  1553.76 s
2272 records/s
real 60.00 s
user 10.44 s
sys  1510.90 s
2404 records/s
real 60.00 s
user 10.96 s
sys  1563.49 s

overcommit 2 x
2454 records/s
real 60.00 s
user 14.66 s
sys  880.17 s
2192 records/s
real 60.00 s
user 15.56 s
sys  881.12 s
2329 records/s
real 60.00 s
user 17.56 s
sys  933.03 s
2281 records/s
real 60.00 s
user 16.22 s
sys  925.34 s
2286 records/s
real 60.00 s
user 16.93 s
sys  902.04 s
2289 records/s
real 60.00 s
user 15.53 s
sys  909.78 s
2586 records/s
real 60.00 s
user 15.38 s
sys  857.22 s
2675 records/s
real 60.00 s
user 15.93 s
sys  842.40 s

kernbench
=============
overcommit 1 x
Elapsed Time 36.6633 (33.6422)
User Time 248.303 (359.64)
System Time 123.003 (67.1702)
Percent CPU 864 (242.52)
Context Switches 44936.3 (28799.8)
Sleeps 76076.7 (41142.1)
--
Elapsed Time 37.9167 (37.3285)
User Time 247.517 (358.659)
System Time 118.883 (86.7824)
Percent CPU 807.333 (245.133)
Context Switches 44219.3 (29480.9)
Sleeps 77137.3 (42685.4)
--
Elapsed Time 39.65 (39.0432)
User Time 248.07 (357.765)
System Time 100.76 (58.7603)
Percent CPU 748.333 (199.803)
Context Switches 42332.3 (27183.7)
Sleeps 75248.7 (41084.4)
--
Elapsed Time 39.2867 (39.8316)
User Time 245.903 (356.194)
System Time 101.783 (60.4971)
Percent CPU 762.667 (186.827)
Context Switches 42289.3 (24882.1)
Sleeps 74964.7 (38139.1)

overcommit 2 x
Elapsed Time 85.6567 (92.092)
User Time 274.607 (370.598)
System Time 172.12 (134.705)
Percent CPU 496.667 (34.2977)
Context Switches 45715.7 (29180.4)
Sleeps 76054 (34844.5)
--
Elapsed Time 86.8667 (92.72)
User Time 278.767 (365.877)
System Time 193.277 (142.811)
Percent CPU 538.667 (36.5558)
Context Switches 48035.3 (32107.3)
Sleeps 78004.7 (37835.6)
--
Elapsed Time 87.38 (91.6723)
User Time 269.133 (374.608)
System Time 165.283 (122.423)
Percent CPU 465.667 (119.068)
Context Switches 45107.3 (29571.6)
Sleeps 76942.7 (33102.4)
--
Elapsed Time 83.6333 (96.6314)
User Time 267.97 (374.691)
System Time 156.843 (123.183)
Percent CPU 503 (28.5832)
Context Switches 44406.7 (30002.8)
Sleeps 78975.7 (40787.4)

sysbench
=================
overcommit 1 x
     total time:                          11.7338s
     total number of events:              100021
     total time taken by event execution: 747.8628
--
     total time:                          11.9323s
     total number of events:              100006
     total time taken by event execution: 760.7567
--
     total time:                          12.0282s
     total number of events:              100068
     total time taken by event execution: 766.2259
--
     total time:                          12.0065s
     total number of events:              100010
     total time taken by event execution: 765.0691
--
     total time:                          12.2033s
     total number of events:              100016
     total time taken by event execution: 777.9971
--
     total time:                          12.2472s
     total number of events:              100041
     total time taken by event execution: 780.9914
--
     total time:                          12.4853s
     total number of events:              100015
     total time taken by event execution: 795.9082
--
     total time:                          12.7028s
     total number of events:              100015
     total time taken by event execution: 810.4563

overcommit 2 x
     total time:                          13.7335s
     total number of events:              100005
     total time taken by event execution: 872.0665
--
     total time:                          14.0005s
     total number of events:              100010
     total time taken by event execution: 892.4587
--
     total time:                          13.8066s
     total number of events:              100008
     total time taken by event execution: 880.2714
--
     total time:                          14.6350s
     total number of events:              100006
     total time taken by event execution: 875.3052
--
     total time:                          13.8536s
     total number of events:              100007
     total time taken by event execution: 877.8040
--
     total time:                          15.7213s
     total number of events:              100007
     total time taken by event execution: 896.5455
--
     total time:                          13.9135s
     total number of events:              100007
     total time taken by event execution: 882.0964
--
     total time:                          13.8390s
     total number of events:              100009
     total time taken by event execution: 881.8267

