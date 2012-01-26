Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2AZWYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:24:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65282 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab2AZWYW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:24:22 -0500
MIME-Version: 1.0
X-Originating-IP: [59.167.234.130]
In-Reply-To: <20120126.133033.964571202129052712.davem@davemloft.net>
References: <CAGsizzJnRy74ni-HH=5q1VR4g6sfDPg9SFw4UKgSjJjkSR8OJA@mail.gmail.com>
	<20120125.203746.1977019610549185259.davem@davemloft.net>
	<CAGsizzLYxsc2MGxF7yK_QzS+3bexHa1F_6+NE87u3F18m7=R1g@mail.gmail.com>
	<20120126.133033.964571202129052712.davem@davemloft.net>
Date: Fri, 27 Jan 2012 09:24:19 +1100
Message-ID: <CAOzFzEj-UCXwhw0NA=Y=qExG=RdVJB3RAdqU0HrsMo7V+4eGcQ@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: David Miller <davem@davemloft.net>
Cc: steweg@ynet.sk, jesse@nicira.com, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David is correct, the forwarding speed of Open vSwitch is at parity
with the Linux Bridging module and its tunneling speed is actually
slightly faster than the in kernel GRE implementation. I have tested
this across a variety of configurations.

Joseph.

On 27 January 2012 05:30, David Miller <davem@davemloft.net> wrote:
> From: Štefan Gula <steweg@ynet.sk>
> Date: Thu, 26 Jan 2012 11:57:30 +0100
>
>> 2012/1/26 David Miller <davem@davemloft.net>:
>>> From: Štefan Gula <steweg@ynet.sk>
>>> Date: Wed, 25 Jan 2012 23:57:18 +0100
>>>
>>>> The performance is one of the most critical thing why I have chosen to
>>>> build kernel patch in the first place instead of some user-space app.
>>>> If I used this approach, I would probably end up with patch for
>>>> OpenVPN project instead in that time. I am not telling that
>>>> openvswitch is not a good place for prototyping, but I believe that
>>>> this patch is beyond that border as it successfully run in environment
>>>> with more 98 linux-based APs, used for 4K+ users, with no issue for
>>>> more than 2 years. The performance results from Joseph Glanville even
>>>> adds value to it. So I still don't get the point, why my patch and
>>>> openvswitch cannot coexists in the kernel together and let user/admin
>>>> to choose to correct solution for him/her.
>>>
>>> You don't even know if openvswitch could provide acceptable levels
>>> of performance, because you haven't even tried.
>>>
>>> I'm not applying your patch.
>> Performance of any user-space application is lower than performance of
>> something running purely inside the kernel-space only. So still don't
>> see any valid reason, why it simply cannot coexists as it doesn't
>> breaks any existing functionality at all?
>
> The only userspace component is setting up the rules, the actual
> packet processing occurs in the openvswitch kernel code.
>
> Are you really unable to understand this?



-- 
Founder | Director | VP Research
Orion Virtualisation Solutions | www.orionvm.com.au | Phone: 1300 56
99 52 | Mobile: 0428 754 846
