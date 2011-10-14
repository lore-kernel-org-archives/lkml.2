Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab1JNQkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:40:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab1JNQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:40:01 -0400
Message-ID: <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
Cc: "Seger, Mark" <mark.seger@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 18:40:16 +0200
In-Reply-To: <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 17:27 +0100, Oberman, Laurence (HAS GSE) a
écrit :
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

