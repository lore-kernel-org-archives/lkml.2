Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1J0HNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:13:06 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:50990 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381Ab1J0HNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:13:04 -0400
Message-ID: <4EA9047C.5060604@profihost.ag>
Date: Thu, 27 Oct 2011 09:13:00 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        s.priebe@profihost.ag
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org> <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com> <4EA506B9.4030604@profihost.ag> <alpine.DEB.2.00.1110261322460.23111@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110261322460.23111@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.10.2011 22:26, schrieb David Rientjes:
> On Mon, 24 Oct 2011, Philipp Herz - Profihost AG wrote:
>
>> we have recompiled the kernel of one machine with CONFIG_SLUB instead of
>> CONFIG_SLAB, but it is showing similar message.
>>
>> Now it's showing failure at "order:5, mode:0x4020".
>>
>> Call trace can be found at:
>> * http://pastebin.com/uGJiwvG1
>>
>> Comparing kernel 2.6.32 (mm/page_alloc.c) there seams to be the same way of
>> dealing with page allocation.
>>
>> Do you have an idea why these (warning) messages do never appear running
>> 2.6.32?
>>
>
> Do you have CONFIG_COMPACTION enabled?  Perhaps this is a difference in
> the deprecation of lumpy reclaim between 2.6.35 and 2.6.38 and
> defragmentation being done by memory compaction instead.
Yes CONFIG_COMPACTION is enabled as a dependency for 
TRANSPARENT_HUGEPAGE which is different to the configs before.

>
> It won't be triggered synchronously in this context since it's a
> GFP_ATOMIC allocation, which is why it emits a page allocation failure in
> the first place, but it will show whether defragmentation is the issue or
> you're just simply low on memory.
Do you mean that "memory compaction" should be turned off again?

How can I see the difference between "deframentation issue" and "low 
memory"? I did not get this point.
