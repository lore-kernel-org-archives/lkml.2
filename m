Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0CWEwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0CWEwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:52:45 -0400
Message-ID: <4BA849F5.30704@redhat.com>
Date: Tue, 23 Mar 2010 12:56:21 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, elendil@planet.nl,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch v2] netpoll: warn when there are spaces in parameters
References: <20100322090341.5289.10770.sendpatchset@localhost.localdomain>	 <1269296535.3552.10.camel@calx>  <4BA81D18.40509@redhat.com>	 <1269318256.3552.49.camel@calx>  <4BA844E6.6060602@redhat.com> <1269319520.3552.76.camel@calx>
In-Reply-To: <1269319520.3552.76.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, 2010-03-23 at 12:34 +0800, Cong Wang wrote:
>> Matt Mackall wrote:
>>> On Tue, 2010-03-23 at 09:44 +0800, Cong Wang wrote:
>>>> Matt Mackall wrote:
>>>>> On Mon, 2010-03-22 at 04:59 -0400, Amerigo Wang wrote:
>>>>>> +			printk(KERN_INFO "%s: warning: whitespace"
>>>>>> +					"is not allowed\n", np->name);
>>>>> Is it a warning or is it info? If it's a warning, then we probably need
>>>>> to add "netpoll" or whatever to the message so that people who've got a
>>>>> warning-level threshold will know what it's about.
>>>>>
>>>> If you mean KERN_INFO, yeah, I want to keep it in the same level
>>>> as other messages around.
>>> I should probably be more direct: I think that's the wrong thing to do.
>>> It IS a warning (it even says so!) telling users that something probably
>>> won't work and why and they might miss it if the severity is INFO and
>>> then come and ask us why things aren't working. So use KERN_WARN,
>>> please.
>>
>> They _are_ working, 0 will be assigned by default.
> 
> If this patch has any point at all other than filling the logs, it
> should be WARN.

Others too.

> 
>>> The other messages are INFO because when things are working, they're not
>>> interesting.
>>>
>> They are not all working, take this as an example:
>>
>>          printk(KERN_INFO "%s: couldn't parse config at %s!\n",
>>                 np->name, cur);
> 
> Yeah, that's obviously wrong too. Let's not add more wrongness just for
> consistency's sake.
> 

Since you insist, please send a patch for all of these messages
in netpoll. This patch, from $subject, is aimed to warn spaces.

Thanks.
