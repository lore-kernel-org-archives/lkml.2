Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0KFH0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 03:26:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46637 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0KFH0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 03:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QmdB2BRrDvV8bNfJDkTJyUTrxfsKG9TjGtqun0wpbRY21vLffAPohh+eOqtYCWIIED
         GZs6fLwRHnXNyzerd574xCz5wojnSizYjhX2K6ujwMbCUdzAnK4wIPK5ls1s/2y8qdIF
         pTM0JPwF7FTo8gtWQtGzO8Qws3LmJEa8mS/WY=
Subject: Re: OOM when adding ipv6 route:  How to make available more
 per-cpu memory?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <4CD49C2F.3060904@candelatech.com>
References: <4CD43C87.5040403@candelatech.com>
	 <1288980361.2882.1070.camel@edumazet-laptop>
	 <4CD449A5.5070305@candelatech.com>
	 <1288988403.2665.268.camel@edumazet-laptop>
	 <1288995103.2665.653.camel@edumazet-laptop>
	 <4CD49C2F.3060904@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 08:26:32 +0100
Message-ID: <1289028392.2665.2418.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 17:07 -0700, Ben Greear a écrit :

> We just tried creating 1000 macvlans with IPv6 addrs on a 64-bit machine
> with 12GB RAM.  Only around 520 interfaces properly set their IPs, and
> again there are errors about of-of-memory from 'ip', but no obvious
> splats in dmesg.
> 
> 'top' shows 10G or so free.
> 
> It will take some time to figure out what exactly is returning
> the ENOMEM....

At least, nothing to do with percpu stuff ?

On my 4GB machine, 16 'cpus' (but 32 possible cpus), I was able to
allocate.
8192 percpu 8192 bytes structures

(total : 32 * 8192 * 8192 = 2 Gbytes)

setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:2
PERCPU: Embedded 26 pages/cpu @ffff88007fc00000 s76032 r8192 d22272 u131072
pcpu-alloc: s76032 r8192 d22272 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 02 04 06 08 10 12 14 17 19 21 23 25 27 29 31 
pcpu-alloc: [1] 01 03 05 07 09 11 13 15 16 18 20 22 24 26 28 30 

grep Vmalloc /proc/meminfo 
VmallocTotal:   34359738367 kB
VmallocUsed:     2202592 kB
VmallocChunk:   34356996456 kB

Make sure udev / hotplug is not the problem, if you create your devices
very fast.

(modprobe dummy numdummies=2000) can be very slow because of that.
All tasks are fighting for RTNL or sysfs mutex.



