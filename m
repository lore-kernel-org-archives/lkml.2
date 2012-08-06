Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2HFOEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:04:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61334 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab2HFOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:04:34 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 16:04:32 +0200
Message-ID: <CAC_CU1hzuSAeHG7-5g5kOa=MMh3KnJZNwWr+ySkJQyxixck4WA@mail.gmail.com>
Subject: unfair scheduling with tbb application observed, could it be a kernel issue?
From: Pedro Larroy <pedro.larroy.lists@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I think we are observing unfair scheduling of processes that use intel
TBB thread scheduler, as we have several processes with nice of 19 and
ioniced idle, and somehow the process with nice 0 should be getting
more than 1000% cpu

Any ideas? Kernel is 3.0.0.-17-generic on unbutu 11.10.


Avg[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||99.6%]
Tasks: 331; 81 running
Mem[||||||||||||||||||||||||||||||||||||||||||||||||||||||||36386/96868MB]
Load average: 76.99 46.08 34.32
Swp[|||||||||
534/4099MB] Time: 15:51:51
  PID USER     PRI  NI  VIRT   RES   SHR S CPU% MEM%   TIME+  Command
10597 disco     39  19 6772M 6366M 14384 R 636.  6.6 37:56.63
/map_store/developers/disco/12_08_06-13_53_1344254009-j3UGmL/mmcc -X
178 -c /map_store/de
11629 visciano  20   0 6106M 5504M 18668 R 585.  5.7 39:02.15
build/release/mmcc -D --compact -f 8 -h bfmapcomp03.europe.nokia.com
-d 1521 -s LDMTEST -
10235 disco     39  19 4566M 4190M 12512 R 197.  4.3 25:13.58
/map_store/developers/disco/12_08_06-13_53_1344254009-j3UGmL/mmcc -X
183 -c /map_store/de
11599 disco     39  19 4935M 4644M 12572 R 188.  4.8 15:44.48
/map_store/developers/disco/12_08_06-13_53_1344254009-j3UGmL/mmcc -X
176 -c /map_store/de
11996 disco     39  19 4407M 4164M 12580 R 103.  4.3 12:08.25
/map_store/developers/disco/12_08_06-13_53_1344254009-j3UGmL/mmcc -X
174 -c /map_store/de
12630 disco     39  19 1804M 1589M 12248 R 101.  1.6  4:31.51
/map_store/developers/disco/12_08_06-13_53_1344254009-j3UGmL/mmcc -X
172 -c /map_store/de

Another example, the processes at 100% not being throttled at all when
having more processes waiting with higher priority:


Tasks: 559 total,  37 running, 522 sleeping,   0 stopped,   0 zombie
Cpu(s): 67.8%us, 16.0%sy, 13.0%ni,  1.7%id,  0.6%wa,  0.0%hi,  1.0%si,  0.0%st
Mem:  98998032k total, 97444688k used,  1553344k free,    53772k buffers
Swap:  4198316k total,   704860k used,  3493456k free, 73270776k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
14373 disco     39  19 8734m 6.9g  12m R  107  7.3  36:09.72 mmcc
15293 disco     39  19 3174m 1.4g  12m R  101  1.5  19:33.79 mmcc
20341 disco     39  19 2735m 1.1g  12m R  101  1.1   8:40.38 mmcc
18241 disco     39  19 3040m 1.3g  11m R  100  1.4  14:27.91 mmcc
15204 disco     39  19 5418m 3.7g  12m R   99  3.9  20:53.89 mmcc
24901 larroy    20   0  327m 296m 4276 R   88  0.3   0:04.14 cc1plus
24942 larroy    20   0  193m 159m 4008 R   87  0.2   0:01.47 cc1plus
24862 larroy    20   0  417m 388m 7992 R   84  0.4   0:07.02 cc1plus
24959 larroy    20   0  184m 153m 4008 R   80  0.2   0:01.32 cc1plus
24935 larroy    20   0  254m 222m 4024 R   77  0.2   0:02.44 cc1plus
24919 larroy    20   0  336m 301m 4036 R   76  0.3   0:03.61 cc1plus
24972 larroy    20   0 43160  15m 2332 R   76  0.0   0:00.95 cc1plus
24918 larroy    20   0  287m 255m 4024 R   70  0.3   0:02.99 cc1plus
24962 larroy    20   0 44872  17m 2332 R   69  0.0   0:01.23 cc1plus
24976 larroy    20   0 41212  14m 2332 R   66  0.0   0:00.67 cc1plus
24501 larroy    20   0  687m 657m 8044 R   64  0.7   0:22.97 cc1plus
24933 larroy    20   0  211m 177m 4008 R   62  0.2   0:01.79 cc1plus
24899 larroy    20   0  327m 296m 4276 R   57  0.3   0:04.25 cc1plus

This is 3.2.0-26-generic on ubuntu 12.04

Regards.

Pedro.
