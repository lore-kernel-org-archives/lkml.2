Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab0J0PVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:21:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39807 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab0J0PVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=naoPMcLNMjcmV6vCeNXIP1SZ7Jkfao87Mz976T4B4wurvaVOxd8LVV36V439GDilXY
         7B17YLMk3x4ojdJ1R7VNlEKtrsXfwmXwA/Xvtxz7DBYmNyJBtDN6fLb9LHbhczORLk90
         LXv3KVyTS7vLEU+yO9yH/3+Kvdj/cC/dYdfEQ=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC83A85.3070608@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 17:21:08 +0200
Message-ID: <1288192868.2709.152.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 16:43 +0200, Tejun Heo a écrit :

> Ah, okay, that explains it.  So, your NUMA table is screwed up.  It
> would be interesting to dig down where the difference between 32 and
> 64bit comes from.  Maybe it's coming from differences in our init code
> rather than from BIOS?
> 

I wish it could explain it.
I upgraded BIOS to latest one from HP. no change.

If I remove HOTPLUG support I still get :


cpu=0 node=1
cpu=1 node=0
cpu=2 node=1
cpu=3 node=0
cpu=4 node=1
cpu=5 node=0
cpu=6 node=1
cpu=7 node=0
cpu=8 node=1
cpu=9 node=0
cpu=10 node=1
cpu=11 node=0
cpu=12 node=1
cpu=13 node=0
cpu=14 node=1
cpu=15 node=0

[    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:8
[    0.000000] PERCPU: Embedded 16 pages/cpu @f4600000 s42752 r0 d22784 u131072
[    0.000000] pcpu-alloc: s42752 r0 d22784 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 


# cat /proc/buddyinfo 
Node 0, zone      DMA      0      1      1      1      2      1      1      0      1      1      3 
Node 0, zone   Normal    362    205     46     13      5      2      2      3      3      3    186 
Node 0, zone  HighMem    182    132    102     70     30      2      1      1      1      1    275 
Node 1, zone  HighMem    140     86    107     41     13      3      4      3      2      2    489 



