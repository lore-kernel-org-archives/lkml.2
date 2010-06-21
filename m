Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0FUE0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:26:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35364 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab0FUE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:26:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 21 Jun 2010 13:21:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: Richard Yao <shiningarcanine@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel does strange things when compilations push memory usage
  above physical memory and the compilations are being done in a tmpfs,
 despite  having ample swap
Message-Id: <20100621132136.b8734516.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikDCq9EzyE_Sfy_sRHN_aBqFOZk9gWap8jDnXLN@mail.gmail.com>
References: <AANLkTikeDoxm6OzWldU5PAr06wvW89asIIPNrpVKoc8I@mail.gmail.com>
	<AANLkTikPAdDuUb37-GPDzFugBYEWNpoSLabcl2Fyt5VY@mail.gmail.com>
	<AANLkTilP5yyJjMqZPhvgv2d22Lrt8ZKB0AoITSEsukgt@mail.gmail.com>
	<20100621120256.8d2a2fca.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikDCq9EzyE_Sfy_sRHN_aBqFOZk9gWap8jDnXLN@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 13:53:02 +1000
Andrew Hendry <andrew.hendry@gmail.com> wrote:

> Kame,
> 
> Could the tempfs revert be the same and fix the ramdisk issue I have seen?
> http://marc.info/?l=linux-kernel&m=127569877714937&w=2
> I can re-test this evening.
> 

I think no. (and IIUC, the patch is included in 2.6.35-rc1)
Anyway, ramdisk isn't swappable, is it ?
And, this doesn't happen in 2.6.33 or 2.6.34 ?

>From your log.
==
Jun  5 04:51:58 jaunty kernel: [25913.310588] firefox-bin invoked
oom-killer: gfp_mask=0xd0, order=1, oom_adj=0
==
Then, order=1 (2-pages contiguous page allocation) failure.

==
Jun  5 05:12:29 jaunty kernel: [27142.500150] Node 0 DMA: 1*4kB 0*8kB
0*16kB 2*32kB 2*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15812kB
Jun  5 05:12:29 jaunty kernel: [27142.500157] Node 0 DMA32: 49660*4kB
14*8kB 4*16kB 6*32kB 1*64kB 2*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB
0*4096kB = 200864kB
Jun  5 05:12:29 jaunty kernel: [27142.500165] Node 0 Normal: 63050*4kB
5*8kB 5*16kB 9*32kB 1*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB
0*4096kB = 255744kB
==
It seems fragmented.

Hmm..
==
MemTotal:        8187304 kB
MemFree:          231976 kB
Active:            14056 kB
Inactive:          72592 kB
Active(anon):      12900 kB
Inactive(anon):    53940 kB
Active(file):       1156 kB
Inactive(file):    18652 kB
Unevictable:           0 kB
Mlocked:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0

AND
5GBytes for ramdisk. (Right ?)
==
There are too small memory used for user program or file caches.

In this kind of case, I tend to doubt memory leak (in kernel)
But I feel ramdisk is very large, too...

How about updating to -rc3 or turning on kmemcheck and see what happens ?


Thanks,
-Kame





