Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1LVKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:04:45 -0500
Received: from yuna.grokhost.net ([87.117.228.63]:54128 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1LVKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:04:42 -0500
Message-ID: <4EF300B2.3050903@bootc.net>
Date: Thu, 22 Dec 2011 10:04:34 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in ipv6_select_ident
References: <4EF200BB.7000209@bootc.net>   <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <4EF2117F.6000803@bootc.net>   <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <4EF23BF2.4000601@bootc.net> <1324499332.2621.7.camel@edumazet-laptop>  <1324500775.2621.9.camel@edumazet-laptop> <4EF2568C.6040006@bootc.net>  <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net> <1324528656.2621.19.camel@edumazet-laptop>
In-Reply-To: <1324528656.2621.19.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/2011 04:37, Eric Dumazet wrote:
> Le mercredi 21 décembre 2011 à 23:12 +0000, Chris Boot a écrit :
>> On 21 Dec 2011, at 21:58, Chris Boot wrote:
>>
>>> On 21/12/2011 20:52, Eric Dumazet wrote:
>>>> Le mercredi 21 décembre 2011 à 21:28 +0100, Eric Dumazet a écrit :
>>>>> Le mercredi 21 décembre 2011 à 20:05 +0000, Chris Boot a écrit :
>>>>>> On 21/12/2011 18:00, Eric Dumazet wrote:
>>>>>>> Le mercredi 21 décembre 2011 à 18:36 +0100, Eric Dumazet a écrit :
>>>>>>>
>>>>>>>> Good point, thats a different problem then, since 3.1 is not supposed to
>>>>>>>> have this bug.
>>>>>>>>
>>>>>>>> It seems rt->rt6i_peer points to invalid memory in your crash.
>>>>>>>>
>>>>>>>> (RBX=00000000000001f4)
>>>>>>>>
>>>>>>>> 8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
>>>>>>>> 1f4+a4 ->    CR2=0000000000000298
>>>>>>>>
>>>>>>> It would help if you can confirm latest linux tree can reproduce the
>>>>>>> bug.
>>>>>> Hi Eric,
>>>>>>
>>>>>> I just built a v3.2-rc6-140-gb9e26df with the same config as the Debian
>>>>>> 3.1.0 kernel. I can reproduce the bug just as easily with this kernel as
>>>>>> with the Debian kernel. Unfortunately I wasn't able to get an entire
>>>>>> trace, for some reason it didn't appear to be printed to the serial port
>>>>>> and hung after the (long) list of loaded kernel modules. The crash
>>>>>> happens at the same offset:
>>>>>>
>>>>> Thanks !
>>>>>
>>>>> Oh well, br_netfilter fake_rtable strikes again.
>>>>>
>>>>> I'll cook a patch in a couple of minutes...
>>>>>
>>>> Could you try following patch ?
>>>>
>>>> [snip]
>>> Eric,
>>>
>>> It looks good! The rsync that caused the crash real quick hasn't done it at all with the patch applied. I'll keep testing it of course, but I think that's done it.
>> No, sorry, false hope. The following does look rather different however:
>>
>> [snip]
> This one is different, its not IPv6 related but IPv4 :
>
> fake_dst_ops lacks a .mtu() field
>
> Bug added in commit 618f9bc74a039da76 (net: Move mtu handling down to
> the protocol depended handlers)
>
> Here is an updated patch, thanks again !
>
> [snip]

Eric,

So far so good. I've had this running for several hours this morning 
with more of the prodding that would normally have crashed it, both IPv4 
and IPv6, and it's holding up well.

Thanks again,
Chris

-- 
Chris Boot
bootc@bootc.net

