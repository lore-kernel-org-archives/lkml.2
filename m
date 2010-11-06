Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0KFRIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:08:53 -0400
Received: from mail.candelatech.com ([208.74.158.172]:35986 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0KFRIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:08:52 -0400
Message-ID: <4CD58B9C.2030006@candelatech.com>
Date: Sat, 06 Nov 2010 10:08:44 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: OOM when adding ipv6 route:  How to make available more per-cpu
 memory?
References: <4CD43C87.5040403@candelatech.com>	 <1288980361.2882.1070.camel@edumazet-laptop>	 <4CD449A5.5070305@candelatech.com>	 <1288988403.2665.268.camel@edumazet-laptop>	 <1288995103.2665.653.camel@edumazet-laptop>	 <4CD49C2F.3060904@candelatech.com> <1289028392.2665.2418.camel@edumazet-laptop>
In-Reply-To: <1289028392.2665.2418.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 12:26 AM, Eric Dumazet wrote:
> Le vendredi 05 novembre 2010 à 17:07 -0700, Ben Greear a écrit :
>
>> We just tried creating 1000 macvlans with IPv6 addrs on a 64-bit machine
>> with 12GB RAM.  Only around 520 interfaces properly set their IPs, and
>> again there are errors about of-of-memory from 'ip', but no obvious
>> splats in dmesg.
>>
>> 'top' shows 10G or so free.
>>
>> It will take some time to figure out what exactly is returning
>> the ENOMEM....
>
> At least, nothing to do with percpu stuff ?

At least I don't see any percpu dumps in dmesg.  I vaguely remember
someone posting some ipv6 address scalability patches some time back.
I think they had to hack on /proc fs as well.  I'll see if I can
dig those up.

> Make sure udev / hotplug is not the problem, if you create your devices
> very fast.

We can create the macvlans w/out problem, though I'm sure that could
be sped up.  The problem is when we try to add IPv6 addresses to
them.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
