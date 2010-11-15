Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0KOJvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:51:52 -0500
Received: from stinky.trash.net ([213.144.137.162]:61105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0KOJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:51:50 -0500
Message-ID: <4CE102B6.9020707@trash.net>
Date: Mon, 15 Nov 2010 10:51:50 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Kevin Cernekee <cernekee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH/RFC] netfilter: nf_conntrack_sip: Handle quirky Cisco
 phones
References: <28d666269c390965f1a4edca42f93c12@localhost>	 <1289725175.2743.65.camel@edumazet-laptop>	 <AANLkTik4PLga8mX73c8iONPeOtpDiuDhfu3xiPmF07jC@mail.gmail.com> <1289764664.2743.110.camel@edumazet-laptop>
In-Reply-To: <1289764664.2743.110.camel@edumazet-laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2010 20:57, Eric Dumazet wrote:
> Le dimanche 14 novembre 2010 à 10:33 -0800, Kevin Cernekee a écrit :
>> On Sun, Nov 14, 2010 at 12:59 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> I would like to get an exact SIP exchange to make sure their is not
>>> another way to handle this without adding a "Cisco" string somewhere...
>>>
>>> Please provide a pcap or tcpdump -A
>>
>> Existing nf_nat_sip: phone sends unauthenticated REGISTER requests
>> over and over again, because it is not seeing the replies sent back to
>> port 50070:
>>
>> 10:05:53.496479 IP 192.168.2.28.50070 > 67.215.241.250.5060: SIP, length: 723
>> E`...[..@.r.....C...........REGISTER sip:losangeles.voip.ms SIP/2.0
>> Via: SIP/2.0/
>>
> 
> Hmm, partial tcpdump... you should use" tcpdump -s 1000 -A" 
> 
> We miss the
> 
> Via: SIP/2.0/UDP 192.168.2.28:5060;branch=xxxxxxxx
> 
> 
> Maybe a fix would be to use this "5060" port, instead of hardcoding it
> like you did ?

I agree, using the Via header to route the response makes more sense.

