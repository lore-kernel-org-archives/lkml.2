Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab1F2EGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 00:06:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1F2EF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 00:05:56 -0400
Date: Wed, 29 Jun 2011 12:05:21 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110629040521.GG4186@localhost.localdomain>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
 <20110626103526.GA11093@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20110626103526.GA11093@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 12:05:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 12:05:15,
	Serialize complete at 2011-06-29 12:05:15
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 12:35:26PM +0200, Ingo Molnar wrote:
> 
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
> > -        865.139070 task-clock                #    0.468 CPUs utilized            ( +-  0.22% )
> > -           200,167 context-switches          #    0.231 M/sec                    ( +-  0.00% )
> > -                 0 CPU-migrations            #    0.000 M/sec                    ( +- 49.62% )
> > -               142 page-faults               #    0.000 M/sec                    ( +-  0.07% )
> > -     1,671,107,623 cycles                    #    1.932 GHz                      ( +-  0.16% ) [28.23%]
> > -       838,554,329 stalled-cycles-frontend   #   50.18% frontend cycles idle     ( +-  0.27% ) [28.21%]
> > -       453,526,560 stalled-cycles-backend    #   27.14% backend  cycles idle     ( +-  0.43% ) [28.33%]
> > -     1,434,140,915 instructions              #    0.86  insns per cycle
> > -                                             #    0.58  stalled cycles per insn  ( +-  0.06% ) [34.01%]
> > -       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
> > -         6,653,998 branch-misses             #    2.38% of all branches          ( +-  0.16% ) [33.93%]
> > -       495,463,378 L1-dcache-loads           #  572.698 M/sec                    ( +-  0.05% ) [28.12%]
> > -        27,903,270 L1-dcache-load-misses     #    5.63% of all L1-dcache hits    ( +-  0.28% ) [27.84%]
> > -           885,210 LLC-loads                 #    1.023 M/sec                    ( +-  3.21% ) [21.80%]
> > -             9,479 LLC-load-misses           #    1.07% of all LL-cache hits     ( +-  0.63% ) [ 5.61%]
> > -       830,096,007 L1-icache-loads           #  959.494 M/sec                    ( +-  0.08% ) [11.18%]
> > -       123,728,370 L1-icache-load-misses     #   14.91% of all L1-icache hits    ( +-  0.06% ) [16.78%]
> > -       504,932,490 dTLB-loads                #  583.643 M/sec                    ( +-  0.06% ) [22.30%]
> > -         2,056,069 dTLB-load-misses          #    0.41% of all dTLB cache hits   ( +-  2.23% ) [22.20%]
> > -     1,579,410,083 iTLB-loads                # 1825.614 M/sec                    ( +-  0.06% ) [22.30%]
> > -           394,739 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.27%]
> > -         2,286,363 L1-dcache-prefetches      #    2.643 M/sec                    ( +-  0.72% ) [22.40%]
> > -           776,096 L1-dcache-prefetch-misses #    0.897 M/sec                    ( +-  1.45% ) [22.54%]
> > +        859.259725 task-clock                #    0.472 CPUs utilized            ( +-  0.24% )
> > +           200,165 context-switches          #    0.233 M/sec                    ( +-  0.00% )
> > +                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
> > +               142 page-faults               #    0.000 M/sec                    ( +-  0.06% )
> > +     1,659,371,974 cycles                    #    1.931 GHz                      ( +-  0.18% ) [28.23%]
> > +       829,806,955 stalled-cycles-frontend   #   50.01% frontend cycles idle     ( +-  0.32% ) [28.32%]
> > +       490,316,435 stalled-cycles-backend    #   29.55% backend  cycles idle     ( +-  0.46% ) [28.34%]
> > +     1,445,166,061 instructions              #    0.87  insns per cycle
> > +                                             #    0.57  stalled cycles per insn  ( +-  0.06% ) [34.01%]
> > +       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]
> > +         5,056,568 branch-misses             #    1.79% of all branches          ( +-  0.19% ) [33.94%]
> > +       500,660,789 L1-dcache-loads           #  582.665 M/sec                    ( +-  0.06% ) [28.05%]
> > +        26,802,313 L1-dcache-load-misses     #    5.35% of all L1-dcache hits    ( +-  0.26% ) [27.83%]
> > +           872,571 LLC-loads                 #    1.015 M/sec                    ( +-  3.73% ) [21.82%]
> > +             9,050 LLC-load-misses           #    1.04% of all LL-cache hits     ( +-  0.55% ) [ 5.70%]
> > +       794,396,111 L1-icache-loads           #  924.512 M/sec                    ( +-  0.06% ) [11.30%]
> > +       130,179,414 L1-icache-load-misses     #   16.39% of all L1-icache hits    ( +-  0.09% ) [16.85%]
> > +       511,119,889 dTLB-loads                #  594.837 M/sec                    ( +-  0.06% ) [22.37%]
> > +         2,452,378 dTLB-load-misses          #    0.48% of all dTLB cache hits   ( +-  2.31% ) [22.14%]
> > +     1,597,897,243 iTLB-loads                # 1859.621 M/sec                    ( +-  0.06% ) [22.17%]
> > +           394,366 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.24%]
> > +         1,897,401 L1-dcache-prefetches      #    2.208 M/sec                    ( +-  0.64% ) [22.38%]
> > +           879,391 L1-dcache-prefetch-misses #    1.023 M/sec                    ( +-  0.90% ) [22.54%]
> > 
> > -       1.847093132 seconds time elapsed                                          ( +-  0.19% )
> > +       1.822131534 seconds time elapsed                                          ( +-  0.21% )
> > =====
> > 
> > As Peter have expected, the number of branches is slightly increased.
> > 
> > -       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
> > +       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]
> > 
> > However, looking overall, I think there is no significant problem on
> > the score with this patch set.  I'd love to hear from maintainers.
> 
> Yeah, these numbers look pretty good. Note that the percentages in 
> the third column (the amount of time that particular event was 
> measured) is pretty low, and it would be nice to eliminate it: i.e. 
> now that we know the ballpark figures do very precise measurements 
> that do not over-commit the PMU.
> 
> One such measurement would be:
> 
> 	-e cycles -e instructions -e branches
> 
> This should also bring the stddev percentages down i think, to below 
> 0.1%.
> 
> Another measurement would be to test not just the feature-enabled but 
> also the feature-disabled cost - so that we document the rough 
> overhead that users of this new scheduler feature should expect.
> 
> Organizing it into neat before/after numbers and percentages, 
> comparing it with noise (stddev) [i.e. determining that the effect we 
> measure is above noise] and putting it all into the changelog would 
> be the other goal of these measurements.

Hi Ingo,

I've tested pipe-test-100k in the following cases: base(no patch), with
patch but feature-disabled, with patch and several periods(quota set to
be a large value to avoid processes throttled), the result is:


                                            cycles                   instructions            branches
-------------------------------------------------------------------------------------------------------------------
base                                        7,526,317,497           8,666,579,347            1,771,078,445
+patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%)
+patch, 10000000000/1000(quota/period)      7,856,873,327 (4.39%)   8,822,227,540 (1.80%)    1,801,766,182 (1.73%)
+patch, 10000000000/10000(quota/period)     7,797,711,600 (3.61%)   8,754,747,746 (1.02%)    1,788,316,969 (0.97%)
+patch, 10000000000/100000(quota/period)    7,777,784,384 (3.34%)   8,744,979,688 (0.90%)    1,786,319,566 (0.86%)
+patch, 10000000000/1000000(quota/period)   7,802,382,802 (3.67%)   8,755,638,235 (1.03%)    1,788,601,070 (0.99%)
-------------------------------------------------------------------------------------------------------------------



These are the original outputs from perf.

base
--------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3834.623919 task-clock                #    0.576 CPUs utilized            ( +-  0.04% )
           200,009 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 48.45% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.12% )
     7,526,317,497 cycles                    #    1.963 GHz                      ( +-  0.07% )
     2,672,526,467 stalled-cycles-frontend   #   35.51% frontend cycles idle     ( +-  0.14% )
     1,157,897,108 stalled-cycles-backend    #   15.38% backend  cycles idle     ( +-  0.29% )
     8,666,579,347 instructions              #    1.15  insns per cycle        
                                             #    0.31  stalled cycles per insn  ( +-  0.04% )
     1,771,078,445 branches                  #  461.865 M/sec                    ( +-  0.04% )
        35,159,140 branch-misses             #    1.99% of all branches          ( +-  0.11% )

       6.654770337 seconds time elapsed                                          ( +-  0.02% )



+patch, cpu cgroup not enabled
------------------------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3872.071268 task-clock                #    0.577 CPUs utilized            ( +-  0.10% )
           200,009 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 69.99% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.17% )
     7,610,354,447 cycles                    #    1.965 GHz                      ( +-  0.11% )
     2,792,310,881 stalled-cycles-frontend   #   36.69% frontend cycles idle     ( +-  0.17% )
     1,268,428,999 stalled-cycles-backend    #   16.67% backend  cycles idle     ( +-  0.33% )
     8,569,448,982 instructions              #    1.13  insns per cycle        
                                             #    0.33  stalled cycles per insn  ( +-  0.10% )
     1,751,675,193 branches                  #  452.387 M/sec                    ( +-  0.09% )
        36,605,163 branch-misses             #    2.09% of all branches          ( +-  0.12% )

       6.707220617 seconds time elapsed                                          ( +-  0.05% )



+patch, 10000000000/1000(quota/period)
--------------------------------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3973.982673 task-clock                #    0.583 CPUs utilized            ( +-  0.09% )
           200,010 context-switches          #    0.050 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.14% )
     7,856,873,327 cycles                    #    1.977 GHz                      ( +-  0.10% )
     2,903,700,355 stalled-cycles-frontend   #   36.96% frontend cycles idle     ( +-  0.14% )
     1,310,151,837 stalled-cycles-backend    #   16.68% backend  cycles idle     ( +-  0.33% )
     8,822,227,540 instructions              #    1.12  insns per cycle        
                                             #    0.33  stalled cycles per insn  ( +-  0.08% )
     1,801,766,182 branches                  #  453.391 M/sec                    ( +-  0.08% )
        37,784,995 branch-misses             #    2.10% of all branches          ( +-  0.14% )

       6.821678535 seconds time elapsed                                          ( +-  0.05% )



+patch, 10000000000/10000(quota/period)
---------------------------------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3948.074074 task-clock                #    0.581 CPUs utilized            ( +-  0.11% )
           200,009 context-switches          #    0.051 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 69.99% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.20% )
     7,797,711,600 cycles                    #    1.975 GHz                      ( +-  0.12% )
     2,881,224,123 stalled-cycles-frontend   #   36.95% frontend cycles idle     ( +-  0.18% )
     1,294,534,443 stalled-cycles-backend    #   16.60% backend  cycles idle     ( +-  0.40% )
     8,754,747,746 instructions              #    1.12  insns per cycle        
                                             #    0.33  stalled cycles per insn  ( +-  0.10% )
     1,788,316,969 branches                  #  452.959 M/sec                    ( +-  0.09% )
        37,619,798 branch-misses             #    2.10% of all branches          ( +-  0.17% )

       6.792410565 seconds time elapsed                                          ( +-  0.05% )



+patch, 10000000000/100000(quota/period)
----------------------------------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3943.323261 task-clock                #    0.581 CPUs utilized            ( +-  0.10% )
           200,009 context-switches          #    0.051 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 56.54% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.24% )
     7,777,784,384 cycles                    #    1.972 GHz                      ( +-  0.12% )
     2,869,653,004 stalled-cycles-frontend   #   36.90% frontend cycles idle     ( +-  0.19% )
     1,278,100,561 stalled-cycles-backend    #   16.43% backend  cycles idle     ( +-  0.37% )
     8,744,979,688 instructions              #    1.12  insns per cycle        
                                             #    0.33  stalled cycles per insn  ( +-  0.10% )
     1,786,319,566 branches                  #  452.999 M/sec                    ( +-  0.09% )
        37,514,727 branch-misses             #    2.10% of all branches          ( +-  0.14% )

       6.790280499 seconds time elapsed                                          ( +-  0.06% )



+patch, 10000000000/1000000(quota/period)
----------------------------------------
 Performance counter stats for './pipe-test-100k' (50 runs):

       3951.215042 task-clock                #    0.582 CPUs utilized            ( +-  0.09% )
           200,009 context-switches          #    0.051 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-  0.00% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.20% )
     7,802,382,802 cycles                    #    1.975 GHz                      ( +-  0.12% )
     2,884,487,463 stalled-cycles-frontend   #   36.97% frontend cycles idle     ( +-  0.17% )
     1,297,073,308 stalled-cycles-backend    #   16.62% backend  cycles idle     ( +-  0.35% )
     8,755,638,235 instructions              #    1.12  insns per cycle        
                                             #    0.33  stalled cycles per insn  ( +-  0.11% )
     1,788,601,070 branches                  #  452.671 M/sec                    ( +-  0.11% )
        37,649,606 branch-misses             #    2.10% of all branches          ( +-  0.15% )

       6.794033052 seconds time elapsed                                          ( +-  0.06% )

