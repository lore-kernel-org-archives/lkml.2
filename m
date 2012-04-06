Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2DFJj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:39:58 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:53212 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2DFJj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:39:56 -0400
MIME-Version: 1.0
X-Mailer: AfterLogic WebMail PHP
X-Originating-IP: 172.24.1.200
X-Priority: 3 (Normal)
Message-ID: <6dfqp4f.4ae84ae68d6556b1585957b381280d94@obelix.schillstrom.com>
From: "Hans Schillstrom" <hans@schillstrom.com>
To: "Sasha Levin" <levinsasha928@gmail.com>
Cc: "Simon Horman" <horms@verge.net.au>, wensong@linux-vs.org, ja@ssi.bg,
        kaber@trash.net, davem@davemloft.net, davej@redhat.com,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re[2]:  Re[2]: [PATCH] netfilter: ipvs: Verify that IP_VS 
	protocol has been registered
Date: Fri, 6 Apr 2012 11:39:50 +0200 (CEST)
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sasha

>---- Original Message ----
>From: Sasha Levin <levinsasha928@gmail.com>
>To: "Hans Schillstrom" <hans@schillstrom.com>
>Cc: "Simon Horman" <horms@verge.net.au>, wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
>Sent: Fri, Apr 6, 2012, 11:22 AM
>Subject: Re: Re[2]: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been registered
>
>On Fri, Apr 6, 2012 at 10:59 AM, Hans Schillstrom <hans@schillstrom.com> wrote:
>> Hello Simon
>>
>>>---- Original Message ----
>>>From: Simon Horman <horms@verge.net.au>
>>>To: "Sasha Levin" <levinsasha928@gmail.com>
>>>Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
>>>Sent: Fri, Apr 6, 2012, 1:19 AM
>>>Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been registered
>>>
>>>On Thu, Apr 05, 2012 at 07:24:33PM -0400, Sasha Levin wrote:
>>>> The registration of a protocol might fail, there were no checks
>>>> and all registrations were assumed to be correct. This lead to
>>>> NULL ptr dereferences when apps tried registering.
>>>
>>>Thanks, I will queue up this fix.
>>>
>>>Do you have a real-world example of this failing, if so it
>>>might be worth pushing your change into stable.
>>
>> I don't think this is a big thing, the only thing that can cause it is out of memory,
>> and that will cause a "kernel death" anyway :-(
>>
>> here is the code :
>>
>> register_ip_vs_proto_netns(struct net *net, struct ip_vs_protocol *pp)
>> {
>> ...
>>        struct ip_vs_proto_data *pd =
>>                        kzalloc(sizeof(struct ip_vs_proto_data), GFP_ATOMIC);
>>
>>        if (!pd)
>>                return -ENOMEM;
>>
>>
>
>Considering that the allocation gfp flag here is GFP_ATOMIC (why is it
>GFP_ATOMIC btw?), it might fail for a variety of reasons which may
>occur when the system is "healthy", for example - if it needs disk I/O
>to allocate.

Hmm, I think it should be GFP_KERNEL
I will have a look at this, and make it consistent with the rest of the netns allocations,

>
>Either way, you shouldn't be dereferencing NULL ptrs even when the
>system is really low on memory.

Of course not, it's a bug  

Simon:
I think you should push this one into stable 


Thanks Sasha


Regards
Hans 


