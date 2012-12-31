Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2LaHwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 02:52:53 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:52959 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2LaHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 02:52:51 -0500
MIME-Version: 1.0
In-Reply-To: <1356939140-4113-1-git-send-email-ling.ma@alipay.com>
References: <1356939140-4113-1-git-send-email-ling.ma@alipay.com>
Date: Mon, 31 Dec 2012 15:52:49 +0800
Message-ID: <CAOGi=dNXH2=dnqpjUEnLE8wkzQLdkEkBfQ3fBeq1jY71TFL8Gg@mail.gmail.com>
Subject: Re: [Suggestion] [x86]: Compiler Option Os is better on latest x86
From: Ling Ma <ling.ma.program@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b6d8672bdbd1104d2214c68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d8672bdbd1104d2214c68
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

By netperf we did double check on older Nehalem platform too as below:

O2 NHM
 Performance counter stats for 'netperf' (3 runs):

       3779.262214 task-clock                #    0.378 CPUs utilized
          ( +-  0.37% )
            47,580 context-switches          #    0.013 M/sec
          ( +-  0.59% )
                 0 cpu-migrations            #    0.000 K/sec
               321 page-faults               #    0.085 K/sec
          ( +-  0.18% )
     8,885,976,365 cycles                    #    2.351 GHz
          ( +-  0.37% )
     4,572,094,199 stalled-cycles-frontend   #   51.45% frontend
cycles idle     ( +-  1.27% )
     1,347,935,497 stalled-cycles-backend    #   15.17% backend
cycles idle     ( +-  2.02% )
     6,564,928,770 instructions              #    0.74  insns per cycle
                                             #    0.70  stalled cycles
per insn  ( +-  0.33% )
     1,196,254,990 branches                  #  316.531 M/sec
          ( +-  0.33% )
         6,434,145 branch-misses             #    0.54% of all
branches          ( +-  0.42% )

      10.009993130 seconds time elapsed
          ( +-  0.04% )

 87380  16384  16384    10.00    16727.94


Os NHM

 Performance counter stats for 'netperf' (3 runs):

       3793.965782 task-clock                #    0.379 CPUs utilized
          ( +-  0.24% )
            59,124 context-switches          #    0.016 M/sec
          ( +-  0.02% )
                 0 cpu-migrations            #    0.000 K/sec
               321 page-faults               #    0.085 K/sec
          ( +-  0.21% )
     8,878,307,926 cycles                    #    2.340 GHz
          ( +-  0.25% )
     4,717,512,228 stalled-cycles-frontend   #   53.14% frontend
cycles idle     ( +-  0.56% )
     1,612,028,376 stalled-cycles-backend    #   18.16% backend
cycles idle     ( +-  0.58% )
     6,273,760,790 instructions              #    0.71  insns per cycle
                                             #    0.75  stalled cycles
per insn  ( +-  0.02% )
     1,144,007,254 branches                  #  301.533 M/sec
          ( +-  0.02% )
        11,348,742 branch-misses             #    0.99% of all
branches          ( +-  0.66% )

      10.006341837 seconds time elapsed
          ( +-  0.00% )

 During the same time IPC from O2 is 0.74, 0.71 from Os, so the
performance is improved by 4%

The above result verified our thought, O2 is better than Os on Nehalem
because Nehalem use legacy instruction fetch, and -falign-functions,
-falign-jumps, -falign-loops, -falign-labels are useful to improve
frontend throuput and Os is good for Sandy Bridge resulted from
decoded cache.

Any comments are appreciate.

Thanks & Best Wish for coming year!
Ling

2012/12/31, ling.ma.program@gmail.com <ling.ma.program@gmail.com>:
> From: Ma Ling <ling.ml@alipay.com>
>
>   Currently we use O2 as compiler option for better performance,
> although it will enlarge code size, in modern CPUs larger instructon
> and unified cache, sophisticated instruction prefetch weaken instruction
> cache miss, meanwhile flags such as -falign-functions, -falign-jumps,
> -falign-loops, -falign-labels are very helpful to improve CPU front-end
> throughput because CPU fetch instruction by 16 aligned=96bytes code block
> per cycle.
>
>   In order to save power and get higher performance, Sandy Bridge
> starts to introduce decoded-cache, instructions will be kept in it
> after decode stage. When CPU refetches the instruction, decoded cache cou=
ld
> provide 32 aligned-bytes instruction block, instead of 16 bytes from
> I-cache,
> fewer branch miss penalty resulted from shorter pipeline. It requires hot
> code should be put into decoded cache as possible we can. Sandy Bridge,
> Ivy Bridge, and Haswell all implemented this feature, Os-Optimize for siz=
e
> should be better than O2 on them.
>
> Based on above reasons, we compiled linux kernel 3.6.9 with O2 and Os
> respectively. The results show Os improve performance netperf 4.8%,
> 2.7% for volano as below
>
> O2 + netperf
> Performance counter stats for 'netperf' (3 runs):
>
>        5416.157986 task-clock                #    0.541 CPUs utilized
>     ( +-  0.19% )
>            348,249 context-switches          #    0.064 M/sec
>     ( +-  0.17% )
>                  0 CPU-migrations            #    0.000 M/sec
>     ( +-  0.00% )
>                353 page-faults               #    0.000 M/sec
>     ( +-  0.16% )
>     13,166,254,384 cycles                    #    2.431 GHz
>     ( +-  0.18% )
>      8,827,499,807 stalled-cycles-frontend   #   67.05% frontend cycles i=
dle
>     ( +-  0.29% )
>      5,951,234,060 stalled-cycles-backend    #   45.20% backend  cycles i=
dle
>     ( +-  0.44% )
>      8,122,481,914 instructions              #    0.62  insns per cycle
>                                              #    1.09  stalled cycles pe=
r
> insn  ( +-  0.17% )
>      1,415,864,138 branches                  #  261.415 M/sec
>     ( +-  0.17% )
>         16,975,308 branch-misses             #    1.20% of all branches
>     ( +-  0.61% )
>
>       10.007215371 seconds time elapsed
>     ( +-  0.03% )
>
> Os + netperf
>
> Performance counter stats for 'netperf' (3 runs):
>
>        5395.386704 task-clock                #    0.539 CPUs utilized
>     ( +-  0.14% )
>            345,880 context-switches          #    0.064 M/sec
>     ( +-  0.25% )
>                  0 CPU-migrations            #    0.000 M/sec
>     ( +-  0.00% )
>                354 page-faults               #    0.000 M/sec
>     ( +-  0.00% )
>     13,142,706,297 cycles                    #    2.436 GHz
>     ( +-  0.23% )
>      8,379,382,641 stalled-cycles-frontend   #   63.76% frontend cycles i=
dle
>     ( +-  0.50% )
>      5,513,722,219 stalled-cycles-backend    #   41.95% backend  cycles i=
dle
>     ( +-  0.71% )
>      8,554,202,795 instructions              #    0.65  insns per cycle
>                                              #    0.98  stalled cycles pe=
r
> insn  ( +-  0.25% )
>      1,530,020,505 branches                  #  283.579 M/sec
>     ( +-  0.25% )
>         17,710,406 branch-misses             #    1.16% of all branches
>     ( +-  1.00% )
>
>       10.004859867 seconds time elapsed
>
> During the same time (10.004859867 seconds) IPC from Os is 0.65, O2 is 0.=
62,
> Os improved performance 4.8%
>
> O2 + volano
> Performance counter stats for './loopclient.sh openjdk' (3 runs):
>
>      210627.115313 task-clock                #    0.781 CPUs utilized
>     ( +-  0.92% )
>         13,812,610 context-switches          #    0.066 M/sec
>     ( +-  0.17% )
>          2,352,755 CPU-migrations            #    0.011 M/sec
>     ( +-  0.84% )
>            208,333 page-faults               #    0.001 M/sec
>     ( +-  1.58% )
>    525,627,073,405 cycles                    #    2.496 GHz
>     ( +-  0.96% )
>    428,177,571,365 stalled-cycles-frontend   #   81.46% frontend cycles i=
dle
>     ( +-  1.09% )
>    370,885,224,739 stalled-cycles-backend    #   70.56% backend  cycles i=
dle
>     ( +-  1.18% )
>    187,662,577,544 instructions              #    0.36  insns per cycle
>                                              #    2.28  stalled cycles pe=
r
> insn  ( +-  0.31% )
>     35,684,976,425 branches                  #  169.423 M/sec
>     ( +-  0.45% )
>      1,062,086,942 branch-misses             #    2.98% of all branches
>     ( +-  0.08% )
>
>      269.764578435 seconds time elapsed
>
> Os + volano
> Performance counter stats for './loopclient.sh openjdk' (3 runs):
>
>      209545.786941 task-clock                #    0.778 CPUs utilized
>     ( +-  0.66% )
>         13,864,142 context-switches          #    0.066 M/sec
>     ( +-  0.29% )
>          2,326,826 CPU-migrations            #    0.011 M/sec
>     ( +-  0.83% )
>            205,575 page-faults               #    0.001 M/sec
>     ( +-  2.63% )
>    523,366,588,452 cycles                    #    2.498 GHz
>     ( +-  0.75% )
>    419,200,472,430 stalled-cycles-frontend   #   80.10% frontend cycles i=
dle
>     ( +-  0.86% )
>    362,044,374,737 stalled-cycles-backend    #   69.18% backend  cycles i=
dle
>     ( +-  0.96% )
>    193,274,857,837 instructions              #    0.37  insns per cycle
>                                              #    2.17  stalled cycles pe=
r
> insn  ( +-  0.51% )
>     37,657,832,686 branches                  #  179.712 M/sec
>     ( +-  0.42% )
>      1,061,005,300 branch-misses             #    2.82% of all branches
>     ( +-  0.86% )
>
>      269.410275674 seconds time elapsed
>     ( +-  0.06% )
>
> During the same  time (269.410275674 seconds) IPC from Os is 0.37, O2 is
> 0.36, Os improved performance 2.7%
>
> So our initial conclusion is Os is better than O2 for current & coming x8=
6
> CPUs.
> If I was wrong, please correct me.
>
> Thanks
> Ling
>

--047d7b6d8672bdbd1104d2214c68
Content-Type: text/plain; charset=US-ASCII; name=nhm-cpu-info
Content-Disposition: attachment; filename=nhm-cpu-info
Content-Transfer-Encoding: base64
X-Attachment-Id: file1

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9k
ZWwJCTogNDQKbW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTYy
MCAgQCAyLjQwR0h6CnN0ZXBwaW5nCTogMgptaWNyb2NvZGUJOiAweDEwCmNwdSBNSHoJCTogMjQw
MC4xNzMKY2FjaGUgc2l6ZQk6IDEyMjg4IEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgK
Y29yZSBpZAkJOiAwCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDAKaW5pdGlhbCBhcGljaWQJOiAw
CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDExCndwCQk6IHll
cwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10
cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBz
c2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IHBkcGUxZ2IgcmR0c2NwIGxtIGNvbnN0YW50X3Rz
YyBhcmNoX3BlcmZtb24gcGVicyBidHMgcmVwX2dvb2Qgbm9wbCB4dG9wb2xvZ3kgbm9uc3RvcF90
c2MgYXBlcmZtcGVyZiBwbmkgcGNsbXVscWRxIGR0ZXM2NCBtb25pdG9yIGRzX2NwbCB2bXggc214
IGVzdCB0bTIgc3NzZTMgY3gxNiB4dHByIHBkY20gcGNpZCBkY2Egc3NlNF8xIHNzZTRfMiBwb3Bj
bnQgYWVzIGxhaGZfbG0gYXJhdCBlcGIgZHRoZXJtIHRwcl9zaGFkb3cgdm5taSBmbGV4cHJpb3Jp
dHkgZXB0IHZwaWQKYm9nb21pcHMJOiA0ODAwLjM0CmNsZmx1c2ggc2l6ZQk6IDY0CmNhY2hlX2Fs
aWdubWVudAk6IDY0CmFkZHJlc3Mgc2l6ZXMJOiA0MCBiaXRzIHBoeXNpY2FsLCA0OCBiaXRzIHZp
cnR1YWwKcG93ZXIgbWFuYWdlbWVudDoKCnByb2Nlc3Nvcgk6IDEKdmVuZG9yX2lkCTogR2VudWlu
ZUludGVsCmNwdSBmYW1pbHkJOiA2Cm1vZGVsCQk6IDQ0Cm1vZGVsIG5hbWUJOiBJbnRlbChSKSBY
ZW9uKFIpIENQVSAgICAgICAgICAgRTU2MjAgIEAgMi40MEdIegpzdGVwcGluZwk6IDIKbWljcm9j
b2RlCTogMHgxMApjcHUgTUh6CQk6IDI0MDAuMTczCmNhY2hlIHNpemUJOiAxMjI4OCBLQgpwaHlz
aWNhbCBpZAk6IDAKc2libGluZ3MJOiA4CmNvcmUgaWQJCTogMQpjcHUgY29yZXMJOiA0CmFwaWNp
ZAkJOiAyCmluaXRpYWwgYXBpY2lkCTogMgpmcHUJCTogeWVzCmZwdV9leGNlcHRpb24JOiB5ZXMK
Y3B1aWQgbGV2ZWwJOiAxMQp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1z
ciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVz
aCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBwYmUgc3lzY2FsbCBueCBwZHBl
MWdiIHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29k
IG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVz
NjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHBj
aWQgZGNhIHNzZTRfMSBzc2U0XzIgcG9wY250IGFlcyBsYWhmX2xtIGFyYXQgZXBiIGR0aGVybSB0
cHJfc2hhZG93IHZubWkgZmxleHByaW9yaXR5IGVwdCB2cGlkCmJvZ29taXBzCTogNDgwMC4zNApj
bGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiA2NAphZGRyZXNzIHNpemVzCTogNDAg
Yml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsCnBvd2VyIG1hbmFnZW1lbnQ6Cgpwcm9jZXNz
b3IJOiAyCnZlbmRvcl9pZAk6IEdlbnVpbmVJbnRlbApjcHUgZmFtaWx5CTogNgptb2RlbAkJOiA0
NAptb2RlbCBuYW1lCTogSW50ZWwoUikgWGVvbihSKSBDUFUgICAgICAgICAgIEU1NjIwICBAIDIu
NDBHSHoKc3RlcHBpbmcJOiAyCm1pY3JvY29kZQk6IDB4MTAKY3B1IE1IegkJOiAyNDAwLjE3Mwpj
YWNoZSBzaXplCTogMTIyODggS0IKcGh5c2ljYWwgaWQJOiAwCnNpYmxpbmdzCTogOApjb3JlIGlk
CQk6IDkKY3B1IGNvcmVzCTogNAphcGljaWQJCTogMTgKaW5pdGlhbCBhcGljaWQJOiAxOApmcHUJ
CTogeWVzCmZwdV9leGNlcHRpb24JOiB5ZXMKY3B1aWQgbGV2ZWwJOiAxMQp3cAkJOiB5ZXMKZmxh
Z3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBn
ZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBz
cyBodCB0bSBwYmUgc3lzY2FsbCBueCBwZHBlMWdiIHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJj
aF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFw
ZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3Qg
dG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHBjaWQgZGNhIHNzZTRfMSBzc2U0XzIgcG9wY250IGFl
cyBsYWhmX2xtIGFyYXQgZXBiIGR0aGVybSB0cHJfc2hhZG93IHZubWkgZmxleHByaW9yaXR5IGVw
dCB2cGlkCmJvZ29taXBzCTogNDgwMC4zNApjbGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1l
bnQJOiA2NAphZGRyZXNzIHNpemVzCTogNDAgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFs
CnBvd2VyIG1hbmFnZW1lbnQ6Cgpwcm9jZXNzb3IJOiAzCnZlbmRvcl9pZAk6IEdlbnVpbmVJbnRl
bApjcHUgZmFtaWx5CTogNgptb2RlbAkJOiA0NAptb2RlbCBuYW1lCTogSW50ZWwoUikgWGVvbihS
KSBDUFUgICAgICAgICAgIEU1NjIwICBAIDIuNDBHSHoKc3RlcHBpbmcJOiAyCm1pY3JvY29kZQk6
IDB4MTAKY3B1IE1IegkJOiAyNDAwLjE3MwpjYWNoZSBzaXplCTogMTIyODggS0IKcGh5c2ljYWwg
aWQJOiAwCnNpYmxpbmdzCTogOApjb3JlIGlkCQk6IDEwCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6
IDIwCmluaXRpYWwgYXBpY2lkCTogMjAKZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNw
dWlkIGxldmVsCTogMTEKd3AJCTogeWVzCmZsYWdzCQk6IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3Ig
cGFlIG1jZSBjeDggYXBpYyBzZXAgbXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2gg
ZHRzIGFjcGkgbW14IGZ4c3Igc3NlIHNzZTIgc3MgaHQgdG0gcGJlIHN5c2NhbGwgbnggcGRwZTFn
YiByZHRzY3AgbG0gY29uc3RhbnRfdHNjIGFyY2hfcGVyZm1vbiBwZWJzIGJ0cyByZXBfZ29vZCBu
b3BsIHh0b3BvbG9neSBub25zdG9wX3RzYyBhcGVyZm1wZXJmIHBuaSBwY2xtdWxxZHEgZHRlczY0
IG1vbml0b3IgZHNfY3BsIHZteCBzbXggZXN0IHRtMiBzc3NlMyBjeDE2IHh0cHIgcGRjbSBwY2lk
IGRjYSBzc2U0XzEgc3NlNF8yIHBvcGNudCBhZXMgbGFoZl9sbSBhcmF0IGVwYiBkdGhlcm0gdHBy
X3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDQ4MDAuMzQKY2xm
bHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDQwIGJp
dHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29y
CTogNAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDQK
bW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTYyMCAgQCAyLjQw
R0h6CnN0ZXBwaW5nCTogMgptaWNyb2NvZGUJOiAweDEwCmNwdSBNSHoJCTogMjQwMC4xNzMKY2Fj
aGUgc2l6ZQk6IDEyMjg4IEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJ
OiAwCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDEKaW5pdGlhbCBhcGljaWQJOiAxCmZwdQkJOiB5
ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDExCndwCQk6IHllcwpmbGFncwkJ
OiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1j
YSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0
IHRtIHBiZSBzeXNjYWxsIG54IHBkcGUxZ2IgcmR0c2NwIGxtIGNvbnN0YW50X3RzYyBhcmNoX3Bl
cmZtb24gcGVicyBidHMgcmVwX2dvb2Qgbm9wbCB4dG9wb2xvZ3kgbm9uc3RvcF90c2MgYXBlcmZt
cGVyZiBwbmkgcGNsbXVscWRxIGR0ZXM2NCBtb25pdG9yIGRzX2NwbCB2bXggc214IGVzdCB0bTIg
c3NzZTMgY3gxNiB4dHByIHBkY20gcGNpZCBkY2Egc3NlNF8xIHNzZTRfMiBwb3BjbnQgYWVzIGxh
aGZfbG0gYXJhdCBlcGIgZHRoZXJtIHRwcl9zaGFkb3cgdm5taSBmbGV4cHJpb3JpdHkgZXB0IHZw
aWQKYm9nb21pcHMJOiA0ODAwLjM0CmNsZmx1c2ggc2l6ZQk6IDY0CmNhY2hlX2FsaWdubWVudAk6
IDY0CmFkZHJlc3Mgc2l6ZXMJOiA0MCBiaXRzIHBoeXNpY2FsLCA0OCBiaXRzIHZpcnR1YWwKcG93
ZXIgbWFuYWdlbWVudDoKCnByb2Nlc3Nvcgk6IDUKdmVuZG9yX2lkCTogR2VudWluZUludGVsCmNw
dSBmYW1pbHkJOiA2Cm1vZGVsCQk6IDQ0Cm1vZGVsIG5hbWUJOiBJbnRlbChSKSBYZW9uKFIpIENQ
VSAgICAgICAgICAgRTU2MjAgIEAgMi40MEdIegpzdGVwcGluZwk6IDIKbWljcm9jb2RlCTogMHgx
MApjcHUgTUh6CQk6IDI0MDAuMTczCmNhY2hlIHNpemUJOiAxMjI4OCBLQgpwaHlzaWNhbCBpZAk6
IDAKc2libGluZ3MJOiA4CmNvcmUgaWQJCTogMQpjcHUgY29yZXMJOiA0CmFwaWNpZAkJOiAzCmlu
aXRpYWwgYXBpY2lkCTogMwpmcHUJCTogeWVzCmZwdV9leGNlcHRpb24JOiB5ZXMKY3B1aWQgbGV2
ZWwJOiAxMQp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNl
IGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNw
aSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBwYmUgc3lzY2FsbCBueCBwZHBlMWdiIHJkdHNj
cCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRv
cG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRv
ciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHBjaWQgZGNhIHNz
ZTRfMSBzc2U0XzIgcG9wY250IGFlcyBsYWhmX2xtIGFyYXQgZXBiIGR0aGVybSB0cHJfc2hhZG93
IHZubWkgZmxleHByaW9yaXR5IGVwdCB2cGlkCmJvZ29taXBzCTogNDgwMC4zNApjbGZsdXNoIHNp
emUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiA2NAphZGRyZXNzIHNpemVzCTogNDAgYml0cyBwaHlz
aWNhbCwgNDggYml0cyB2aXJ0dWFsCnBvd2VyIG1hbmFnZW1lbnQ6Cgpwcm9jZXNzb3IJOiA2CnZl
bmRvcl9pZAk6IEdlbnVpbmVJbnRlbApjcHUgZmFtaWx5CTogNgptb2RlbAkJOiA0NAptb2RlbCBu
YW1lCTogSW50ZWwoUikgWGVvbihSKSBDUFUgICAgICAgICAgIEU1NjIwICBAIDIuNDBHSHoKc3Rl
cHBpbmcJOiAyCm1pY3JvY29kZQk6IDB4MTAKY3B1IE1IegkJOiAyNDAwLjE3MwpjYWNoZSBzaXpl
CTogMTIyODggS0IKcGh5c2ljYWwgaWQJOiAwCnNpYmxpbmdzCTogOApjb3JlIGlkCQk6IDkKY3B1
IGNvcmVzCTogNAphcGljaWQJCTogMTkKaW5pdGlhbCBhcGljaWQJOiAxOQpmcHUJCTogeWVzCmZw
dV9leGNlcHRpb24JOiB5ZXMKY3B1aWQgbGV2ZWwJOiAxMQp3cAkJOiB5ZXMKZmxhZ3MJCTogZnB1
IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21v
diBwYXQgcHNlMzYgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBw
YmUgc3lzY2FsbCBueCBwZHBlMWdiIHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9u
IHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYg
cG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2Uz
IGN4MTYgeHRwciBwZGNtIHBjaWQgZGNhIHNzZTRfMSBzc2U0XzIgcG9wY250IGFlcyBsYWhmX2xt
IGFyYXQgZXBiIGR0aGVybSB0cHJfc2hhZG93IHZubWkgZmxleHByaW9yaXR5IGVwdCB2cGlkCmJv
Z29taXBzCTogNDgwMC4zNApjbGZsdXNoIHNpemUJOiA2NApjYWNoZV9hbGlnbm1lbnQJOiA2NAph
ZGRyZXNzIHNpemVzCTogNDAgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsCnBvd2VyIG1h
bmFnZW1lbnQ6Cgpwcm9jZXNzb3IJOiA3CnZlbmRvcl9pZAk6IEdlbnVpbmVJbnRlbApjcHUgZmFt
aWx5CTogNgptb2RlbAkJOiA0NAptb2RlbCBuYW1lCTogSW50ZWwoUikgWGVvbihSKSBDUFUgICAg
ICAgICAgIEU1NjIwICBAIDIuNDBHSHoKc3RlcHBpbmcJOiAyCm1pY3JvY29kZQk6IDB4MTAKY3B1
IE1IegkJOiAyNDAwLjE3MwpjYWNoZSBzaXplCTogMTIyODggS0IKcGh5c2ljYWwgaWQJOiAwCnNp
YmxpbmdzCTogOApjb3JlIGlkCQk6IDEwCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDIxCmluaXRp
YWwgYXBpY2lkCTogMjEKZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNwdWlkIGxldmVs
CTogMTEKd3AJCTogeWVzCmZsYWdzCQk6IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBj
eDggYXBpYyBzZXAgbXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkg
bW14IGZ4c3Igc3NlIHNzZTIgc3MgaHQgdG0gcGJlIHN5c2NhbGwgbnggcGRwZTFnYiByZHRzY3Ag
bG0gY29uc3RhbnRfdHNjIGFyY2hfcGVyZm1vbiBwZWJzIGJ0cyByZXBfZ29vZCBub3BsIHh0b3Bv
bG9neSBub25zdG9wX3RzYyBhcGVyZm1wZXJmIHBuaSBwY2xtdWxxZHEgZHRlczY0IG1vbml0b3Ig
ZHNfY3BsIHZteCBzbXggZXN0IHRtMiBzc3NlMyBjeDE2IHh0cHIgcGRjbSBwY2lkIGRjYSBzc2U0
XzEgc3NlNF8yIHBvcGNudCBhZXMgbGFoZl9sbSBhcmF0IGVwYiBkdGhlcm0gdHByX3NoYWRvdyB2
bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDQ4MDAuMzQKY2xmbHVzaCBzaXpl
CTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDQwIGJpdHMgcGh5c2lj
YWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoK
--047d7b6d8672bdbd1104d2214c68--
