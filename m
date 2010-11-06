Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0KFAHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:07:19 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38942 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0KFAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:07:17 -0400
Message-ID: <4CD49C2F.3060904@candelatech.com>
Date: Fri, 05 Nov 2010 17:07:11 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: OOM when adding ipv6 route:  How to make available more per-cpu
 memory?
References: <4CD43C87.5040403@candelatech.com>	 <1288980361.2882.1070.camel@edumazet-laptop>	 <4CD449A5.5070305@candelatech.com>	 <1288988403.2665.268.camel@edumazet-laptop> <1288995103.2665.653.camel@edumazet-laptop>
In-Reply-To: <1288995103.2665.653.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 03:11 PM, Eric Dumazet wrote:
> Le vendredi 05 novembre 2010 à 21:20 +0100, Eric Dumazet a écrit :
>> Your vmalloc space is very fragmented. pcpu_get_vm_areas() want
>> hugepages (4MB on your machine, 2MB on mine because I have
>> CONFIG_HIGHMEM64G=y)
>
> Well, this is wrong. We use normal (4KB) pages, unfortunately.
>
> I have a NUMA machine, with two nodes, so pcpu_get_vm_areas() allocates
> two zones, one for each node, with a 'known' offset between them.
> Then, 4KB pages are allocated to populate the zone when needed.
>
> # grep pcpu_get_vm_areas /proc/vmallocinfo
> 0xffffe8ffa0400000-0xffffe8ffa0600000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc
> 0xffffe8ffffc00000-0xffffe8ffffe00000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc
>
> BTW, we dont have the number of pages currently allocated in each
> 'vmalloc' zone, and/or node information.
>
> Tejun, do you have plans to use hugepages eventually ?
> (and fallback to 4KB pages, but most percpu data are allocated right
> after boot)

We just tried creating 1000 macvlans with IPv6 addrs on a 64-bit machine
with 12GB RAM.  Only around 520 interfaces properly set their IPs, and
again there are errors about of-of-memory from 'ip', but no obvious
splats in dmesg.

'top' shows 10G or so free.

It will take some time to figure out what exactly is returning
the ENOMEM....

Thanks,
Ben

>
> Thanks
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

