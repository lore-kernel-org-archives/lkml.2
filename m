Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926Ab0J2O4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:56:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27933 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab0J2O4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:56:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 29 Oct 2010 16:58:31 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
In-reply-to: <20101029142741.GB19823@gargoyle.fritz.box>
To: Andi Kleen <andi.kleen@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Message-id: <op.vlcejtth7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
 <op.vlbywq137p4s8u@pikus> <20101029103154.GA10823@gargoyle.fritz.box>
 <20101029195900.88559162.kamezawa.hiroyu@jp.fujitsu.com>
 <20101029122928.GA17792@gargoyle.fritz.box> <op.vlb8bda87p4s8u@pikus>
 <20101029142741.GB19823@gargoyle.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 16:27:41 +0200, Andi Kleen <andi.kleen@intel.com> wrote:

> On Fri, Oct 29, 2010 at 01:43:51PM +0100, Michał Nazarewicz wrote:
>> Hmm... true.  Still the point remains that only movable and reclaimable pages are
>> allowed in the marked regions.  This in effect means that from unmovable pages
>> point of view, the area is unusable but I havn't thought of any other way to
>> guarantee that because of fragmentation, long sequence of free/movable/reclaimable
>> pages is available.

> Essentially a movable zone as defined today.

Ah, right, I somehow was under the impresion that movable zone can be used as a fallback
zone.  When I'm finished with my current approach I'll look more closely into it.

> That gets you near all the problems of highmem (except for the mapping
> problem and you're a bit more flexible in the splits):
>
> Someone has to decide at boot how much should be movable
> and what not, some workloads will run out of space, some may
> deadlock when it runs out of management objects, etc.etc.
> Classic highmem had a long string of issues with all of this.

Here's where the rest of CMA comes.  The solution may be not perfect but it's
probably better then nothing.  The idea is to define regions for each device
(with possibility for a single region to be shared) which, hopefuly, can help
with fragmentation.

In the current form, CMA is designed mostly for embeded systems where one can
define what kind of devices will be used, but in general this could be used
for other systems as well.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
