Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1BBPEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 10:04:15 -0500
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:39601 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1BBPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 10:04:14 -0500
Message-ID: <4D49726C.6020103@univ-nantes.fr>
Date: Wed, 02 Feb 2011 16:04:12 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15pre) Gecko/20110201 Shredder/3.1.9pre
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: kernel 2.6.37 : oops in cleanup_once
References: <4D491B8D.1000107@univ-nantes.fr>	 <1296643972.20445.9.camel@edumazet-laptop>	 <1296645887.20445.11.camel@edumazet-laptop>	 <4D495765.4090806@univ-nantes.fr> <1296658407.20445.19.camel@edumazet-laptop>
In-Reply-To: <1296658407.20445.19.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/02/2011 15:53, Eric Dumazet a écrit :
> Le mercredi 02 février 2011 à 14:08 +0100, Yann Dupont a écrit :
>> Le 02/02/2011 12:24, Eric Dumazet a écrit :
>>> Le mercredi 02 février 2011 à 11:52 +0100, Eric Dumazet a écrit :
>>>> Le mercredi 02 février 2011 à 09:53 +0100, Yann Dupont a écrit :
>>>>> Hello.
>>>>> We recently upgraded one machine with vanilla 2.6.37, and experienced 2
>>>>> kernel oops since. Each oops is after ~1 week of uptime.
>>>>> The last oops was last night but we didn't had any trace.
>>> oops, 2.6.37 "only"
>>>
>>>> Yes this is a known problem.
>>>>
>>>> Please try commit 3408404a4c2a4eead9d73b0bbbfe3f225b65f492
>>>> (inetpeer: Use correct AVL tree base pointer in inet_getpeer())
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3408404a4c2a4eead9d73b0bbbfe3f225b65f492
>>>>
>>>> I believe David will send it to stable team shortly, if not already
>>>> done :)
>>> Please ignore, this patch was for linux-2.6 tree, 2.6.37 was not
>>> affected by the problem.
>>>
>>> So its another problem... Is there anything particular you do on this
>>> machine ?
>>>
>>>
>>>
>>>
>> Nothing really special there, we run a lot (20) of KVM guest (mainly
>> linux firewalls for lots of differents vlan), so we have a lot of
>> bridges vlan&  tun/tap.
>> Oh, and CONFIG_BRIDGE_IGMP_SNOOPING is set to n (because of  the other
>> bug already sent to netdev - more to come on next mail)
>>
>> Hard to say if this BUG is new in 2.6.37. This host was running fine
>> with 2.6.34.2 since August 2010.
>> Bisecting will be hard due to the time to trigger the bug (and the fact
>> that this machine is a production machine)
>>
>> Anyway, I can test with a specific kernel version if you suspect something.
>>
> I suspect a mem corruption from another layer (not inetpeer)
>
> Unfortunately many kmem caches share the "64 bytes" cache.
>
> Could you please add "slub_nomerge" on your boot command ?
>
Ok, will do it at 18:30 CET (to minimize impact)
It the suspected bug SLUB related ?

The 2.6.34.2 kernel previously used on that server used SLAB.


2 questions :
-How can I be sure slub_nomerge is active ? Boot message ?
-Is there a very severe impact on performance ?

Regards,

-- 
Yann Dupont - Service IRTS, DSI Université de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

