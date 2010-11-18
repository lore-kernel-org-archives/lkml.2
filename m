Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab0KRUcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:32:18 -0500
Received: from stinky.trash.net ([213.144.137.162]:41447 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab0KRUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:32:17 -0500
Message-ID: <4CE58D4B.6070105@trash.net>
Date: Thu, 18 Nov 2010 21:32:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, horms@verge.net.au,
        netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
References: <1290093135.2781.167.camel@edumazet-laptop>	<4CE561A2.2020600@gmail.com>	<1290102497.2781.242.camel@edumazet-laptop> <20101118.095046.28818361.davem@davemloft.net> <4CE56CC4.4020107@gmail.com> <4CE56E89.4000902@trash.net> <4CE57C06.4080105@gmail.com>
In-Reply-To: <4CE57C06.4080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2010 20:18, schrieb Justin P. Mattock:
> On 11/18/2010 10:20 AM, Patrick McHardy wrote:
>> Am 18.11.2010 19:13, schrieb Justin P. Mattock:
>>> On 11/18/2010 09:50 AM, David Miller wrote:
>>>> From: Eric Dumazet<eric.dumazet@gmail.com>
>>>> Date: Thu, 18 Nov 2010 18:48:17 +0100
>>>>
>>>>> Let me guess...
>>>>>
>>>>> net/netfilter/nf_conntrack_core is compiled as a module, and ip_vs
>>>>> statically (in vmlinux) ?
>>>>>
>>>>> CONFIG_NF_CONNTRACK=m
>>>>> CONFIG_IP_VS=y
>>>>>
>>>>> We probably need some Kconfig magic ;)
>>>>
>>
>> Please try whether this patch fixes the problem.
>>
>> netfilter: fix IP_VS dependencies
>>
>> When NF_CONNTRACK is enabled, IP_VS uses conntrack symbols.
>> Therefore IP_VS can't be linked statically when conntrack
>> is built modular.
>>
>> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
>> Signed-off-by: Patrick McHardy<kaber@trash.net>
>>
>>
> 
> 
> alright!! doing the above change
> CONFIG_NF_CONNTRACK=y gets a clean build.. as well as reverting
> everything and using your patch..
> 
> Thanks for the fix..

Thanks for testing. Dave, please apply directly, thanks!
