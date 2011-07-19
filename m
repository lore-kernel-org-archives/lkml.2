Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1GSJma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:42:30 -0400
Received: from stinky.trash.net ([213.144.137.162]:35477 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1GSJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:42:29 -0400
Message-ID: <4E255182.8090009@trash.net>
Date: Tue, 19 Jul 2011 11:42:26 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: David Miller <davem@davemloft.net>, rweikusat@mobileactivedefense.com,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
References: <87hb6je5nh.fsf@sapphire.mobileactivedefense.com> <20110718.124638.30010338187296272.davem@davemloft.net> <87d3h7e43n.fsf@sapphire.mobileactivedefense.com> <20110718.131943.1892150276130348431.davem@davemloft.net> <20110718203249.GC2489@p183.telecom.by>
In-Reply-To: <20110718203249.GC2489@p183.telecom.by>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.2011 22:32, Alexey Dobriyan wrote:
> On Mon, Jul 18, 2011 at 01:19:43PM -0700, David Miller wrote:
>> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
>> Date: Mon, 18 Jul 2011 21:17:00 +0100
>>
>>> David Miller <davem@davemloft.net> writes:
>>>> We're also specifically talking about namespace stuff, so you should have
>>>> at least refined your match criteria just a little bit.
>>>
>>> The person I was replying to wrote 'We did whole networking without
>>> sprinkling ifdefs'.
>>
>> He was talking specifically about namespace stuff.
> 
> Indeed.
> 
> Rainer, while your desire to keep CONFIG_NET_NS=n case equivalent
> to current code is understandable and kernel people share it at large,
> what you're fighting for is maybe one dereference on speed-uncritical
> code paths and one pointer in small amount of data structures.
> As such having common executable code matters more.
> 
> netns will be stubbed to &init_net at several places.
> See how e. g. xt_hashlimit is done.

Indeed, that's the alternative to putting it directly into struct
netns, not using tons of ifdefs.
