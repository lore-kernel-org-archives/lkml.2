Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab0J0OBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:01:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:54634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710Ab0J0OBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:01:00 -0400
Message-ID: <4CC83067.5000009@kernel.org>
Date: Wed, 27 Oct 2010 16:00:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>	 <1288159670.2652.181.camel@edumazet-laptop>	 <1288173442.15336.1490.camel@twins>	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org> <1288187870.2709.128.camel@edumazet-laptop>
In-Reply-To: <1288187870.2709.128.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 14:00:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 03:57 PM, Eric Dumazet wrote:
>> What does cpu_to_node() on each cpu say?  Also, do you know why
>> num_possible_cpus() is 32, not 16?
>>
> 
> I dont know, machine is HP ProLiant BL460c G6 
> [    0.000000] SMP: Allowing 32 CPUs, 16 hotplug CPUs
> 
> for_each_possible_cpu(cpu) {
> 	pr_err("cpu=%d node=%d\n", cpu, cpu_to_node(cpu));
> }
> 
> cpu=0 node=1
> cpu=1 node=0
> cpu=2 node=1
> cpu=3 node=0
> cpu=4 node=1
> cpu=5 node=0
> cpu=6 node=1
> cpu=7 node=0
> cpu=8 node=1
> cpu=9 node=0
> cpu=10 node=1
> cpu=11 node=0
> cpu=12 node=1
> cpu=13 node=0
> cpu=14 node=1
> cpu=15 node=0
> cpu=16 node=0
> cpu=17 node=0
> cpu=18 node=0
> cpu=19 node=0
> cpu=20 node=0
> cpu=21 node=0
> cpu=22 node=0
> cpu=23 node=0
> cpu=24 node=0
> cpu=25 node=0
> cpu=26 node=0
> cpu=27 node=0
> cpu=28 node=0
> cpu=29 node=0
> cpu=30 node=0
> cpu=31 node=0

Heh, interesting table.  What does the same code say on 64bit?  Is it
the same?

-- 
tejun
