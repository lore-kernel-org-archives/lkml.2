Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2HFOZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:25:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51024 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756493Ab2HFOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:25:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX190p0JnE2h0I4BbzLCd8YKOas8AhyXBHP8o3Wogfc
	5Jb9gwHUDU2Nel
Message-ID: <1344263139.6853.10.camel@marge.simpson.net>
Subject: Re: unfair scheduling with tbb application observed, could it be a
 kernel issue?
From: Mike Galbraith <efault@gmx.de>
To: Pedro Larroy <pedro.larroy.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Aug 2012 16:25:39 +0200
In-Reply-To: <CAC_CU1hzuSAeHG7-5g5kOa=MMh3KnJZNwWr+ySkJQyxixck4WA@mail.gmail.com>
References: <CAC_CU1hzuSAeHG7-5g5kOa=MMh3KnJZNwWr+ySkJQyxixck4WA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 16:04 +0200, Pedro Larroy wrote: 
> Hi
> 
> I think we are observing unfair scheduling of processes that use intel
> TBB thread scheduler, as we have several processes with nice of 19 and
> ioniced idle, and somehow the process with nice 0 should be getting
> more than 1000% cpu
.. 
> Tasks: 559 total,  37 running, 522 sleeping,   0 stopped,   0 zombie
> Cpu(s): 67.8%us, 16.0%sy, 13.0%ni,  1.7%id,  0.6%wa,  0.0%hi,  1.0%si,  0.0%st
> Mem:  98998032k total, 97444688k used,  1553344k free,    53772k buffers
> Swap:  4198316k total,   704860k used,  3493456k free, 73270776k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 14373 disco     39  19 8734m 6.9g  12m R  107  7.3  36:09.72 mmcc
> 15293 disco     39  19 3174m 1.4g  12m R  101  1.5  19:33.79 mmcc
> 20341 disco     39  19 2735m 1.1g  12m R  101  1.1   8:40.38 mmcc
> 18241 disco     39  19 3040m 1.3g  11m R  100  1.4  14:27.91 mmcc
> 15204 disco     39  19 5418m 3.7g  12m R   99  3.9  20:53.89 mmcc
> 24901 larroy    20   0  327m 296m 4276 R   88  0.3   0:04.14 cc1plus
> 24942 larroy    20   0  193m 159m 4008 R   87  0.2   0:01.47 cc1plus
> 24862 larroy    20   0  417m 388m 7992 R   84  0.4   0:07.02 cc1plus
> 24959 larroy    20   0  184m 153m 4008 R   80  0.2   0:01.32 cc1plus
> 24935 larroy    20   0  254m 222m 4024 R   77  0.2   0:02.44 cc1plus
> 24919 larroy    20   0  336m 301m 4036 R   76  0.3   0:03.61 cc1plus
> 24972 larroy    20   0 43160  15m 2332 R   76  0.0   0:00.95 cc1plus
> 24918 larroy    20   0  287m 255m 4024 R   70  0.3   0:02.99 cc1plus
> 24962 larroy    20   0 44872  17m 2332 R   69  0.0   0:01.23 cc1plus
> 24976 larroy    20   0 41212  14m 2332 R   66  0.0   0:00.67 cc1plus
> 24501 larroy    20   0  687m 657m 8044 R   64  0.7   0:22.97 cc1plus
> 24933 larroy    20   0  211m 177m 4008 R   62  0.2   0:01.79 cc1plus
> 24899 larroy    20   0  327m 296m 4276 R   57  0.3   0:04.25 cc1plus

Are tasks running in per user cgroups or such?  If so, you'd need to
adjust group shares.

-Mike

