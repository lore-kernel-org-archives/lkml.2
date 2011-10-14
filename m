Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab1JNQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:53:22 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45350 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab1JNQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:53:21 -0400
From: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Seger, Mark" <mark.seger@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 17:52:31 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKj+7jmF9MwUzNREinnMJS0dMJ2gAABGow
Message-ID: <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
 <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EGrSdf020305

Standard RHEL kernel build.
What the customer would be using.

[root@linuxbeast boot]# cat config-2.6.32-131.6.1.el6.x86_64 | grep NR
CONFIG_NR_CPUS=4096

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Friday, October 14, 2011 12:40 PM
To: Oberman, Laurence (HAS GSE)
Cc: Seger, Mark; linux-kernel@vger.kernel.org; Cabaniols, Sebastien
Subject: RE: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations

Le vendredi 14 octobre 2011 Ã  17:27 +0100, Oberman, Laurence (HAS GSE) a
Ã©crit :
> Eric,
> 
> Got the system ready and ran the tests.
> 
> This is a DL980 128 CPCUS, 256GB memory.
> 
> [root@linuxbeast ~]# cat /proc/cpuinfo | grep processor | wc -l
> 128
> 
> [root@linuxbeast ~]# uname -a
> Linux linuxbeast.gse.mvlabs.corp.hp.com 2.6.32-131.6.1.el6.x86_64 #1 SMP Mon Jun 20 14:15:38 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> In this example we take >4ms per read. We are spending most of the time in 
> 
>     35.09%        t  [kernel.kallsyms]  [k] kstat_irqs_cpu
>     32.13%        t  [kernel.kallsyms]  [k] find_next_bit
>     24.32%        t  [kernel.kallsyms]  [k] show_stat
>      1.98%        t  [kernel.kallsyms]  [k] vsnprintf
>      1.63%        t  [kernel.kallsyms]  [k] format_decode
>      1.23%        t  [kernel.kallsyms]  [k] number

Hmm, have you compiled your kernel with NR_CPUS=4096 ???

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
