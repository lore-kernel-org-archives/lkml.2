Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0KDRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:21:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab0KDRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MNVcoKIfJCHezBN0Q6UlCXwuNPvRy0yjIn+tQN+JgX1qRS1+ClKX+0sYaiObFGnIYd
         pRz0B8RPwXJeqpM6P/aQ==
Message-ID: <4CD2EB8A.10002@google.com>
Date: Thu, 04 Nov 2010 10:21:14 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Greg KH <greg@kroah.com>,
        simon.kagstrom@netinsight.net, davem@davemloft.net, adurbin@google.com,
        akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v1 00/12] netoops support
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com> <20101103023422.GB5782@kroah.com> <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com> <20101103181634.GF7441@kroah.com> <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com> <4CD1C612.5080902@google.com> <1288817685.26428.1129.camel@calx> <20101104061544.GD5210@cr0.nay.redhat.com>
In-Reply-To: <20101104061544.GD5210@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Wed, Nov 03, 2010 at 03:54:45PM -0500, Matt Mackall wrote:
>> On Wed, 2010-11-03 at 13:29 -0700, Mike Waychison wrote:
>>> Mike Waychison wrote:
>>>> FWIW, another semantic difference between netconsole and netoops (that
>>>> I had missed in the last email) is filtering: we really do want to get
>>>> the whole log when a crash happens, debug messages and all.
>>>> Netconsole is subject to console filtering (which we _do_ want as
>>>> debug messages going out the uart slows the whole world down).
>>>>
>>>> netconsole and netoops _do_ have bits in common, for instance the
>>>> handling of NETDEV events and source+target configuration.  I'd rather
>>>> those bits become common between the two than figure out how to jam
>>>> the semantics we need into netconsole.
>>> Hi Matt,
>>>
>>> I've been reading through the netconsole driver in response to Greg's 
>>> comments on this thread, and it is definitely more robust in terms of 
>>> configuration and handling of network device events than the netoops 
>>> driver I proposed.
>> I've been following the discussion to see if it went anywhere
>> interesting..
>>
>>> What are your thoughts on extending netconsole with the same sort of 
>>> semantics that are in the netoops patchset?
>> My first thought is that it's a bit unfortunate that some of the the
>> netconsole configgy bits weren't implemented in a generic way that would
>> be applicable to other netpoll clients. Some people have never gotten it
>> into their heads that netconsole isn't the only client.
>>
> 
> Really? What are other clients? I remember netdump *was* one client,
> but it is not in upstream and is deprecated, so netconsole is the only
> client in tree, AFAIK.

I see the bonding and bridging drivers using netpoll.

> 
> 
>>> I'd still like to have blit-dmesg-to-the-network-on-oops semantics, 
>>> which seems doable by having a per-target flag for streaming of console 
>>> messages (enabled by default) and a flag to emit a structured full dmesg 
>>> dump (disabled by default).
>> I'd actually like to see you go forward with netoops. It's clear to me
>> that it's a different beast and complexifying netconsole with a bunch of
>> weird new options doesn't really sit well. If that means abstracting
>> some of the sysfs crap from netconsole, great. 
>>
> 
> That would be good.
> 
> 
>> That said, I don't think netoops is an ideal name, given how closely
>> bound oops _events_ are with their textual output. Presumably it covers
>> events other than oopsen like panics too. 
>>
>> Regarding rolling oopses: lots of machines regularly survive oopses, so 
>> I think you ought to consider rate-limiting them (to a configurable rate
>> with a very low default) rather than suppressing all but the first.
>>
> 
> We have WARN_ONCE(), maybe we can make one oops_once()...
> At least, that is not hard.

