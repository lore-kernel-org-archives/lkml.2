Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0DSH5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:57:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27782 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0DSH5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:57:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 19 Apr 2010 09:57:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 3/8] USB: gadget: __init and __exit tags removed
In-reply-to: <n2v8bd0f97a1004161640q640bade7xd4887dde5921b79e@mail.gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Message-id: <op.vbegell27p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1271406290.git.mina86@mina86.com>
 <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com>
 <7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com>
 <41b2cd7e8bacd38bb9c997b7197e175d727876f9.1271406290.git.mina86@mina86.com>
 <n2v8bd0f97a1004161640q640bade7xd4887dde5921b79e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Apr 16, 2010 at 05:49, Michal Nazarewicz wrote:
>> __init, __initdata and __exit tags have have been removed from
>> various files to make it possible for gadgets that do not use
>> the __init/__exit tags to use those.
>>
>> Files in question are related to:
>> * the core composite framework,
>> * the mass storage function (fixing a section mismatch) and
>> * ethernet driver (ACM, ECM, RNDIS).

Mike Frysinger wrote:
> it would be nice if the expected behavior were documented somewhere so
> we dont have to keep thrashing the section markings on the gadget
> drivers.  first they get marked to save space for setups where it
> makes no sense to keep the functions.  then they get tweaked to
> support a semi-dynamic state.  now they're all removed to support yet
> a different setup.

Are you referring to my previous patch by saying "then they get tweaked
to support a semi-dynamic state"? Those were just a proposal which was never
accepted and suggested to remove those tags all together.

> sounds like the system is insufficiently flexible to meet the
> realistic needs of different groups.

Yes, I agree.  That's why in the first version I proposed the __usb_init,
__usb_exit, etc. tags which could be customized prior to including
composite related files.

I would still go with that solution but it was considered, let me
find the exact phrase, "Ick ick ick." :)

What's more, I don't see any other (that is cleaner) solution which
would allow flexibility so it seems what we can either choose
a non-flexible solution proposed by this patch or an ugly solution
proposed by my previous patch.

So basically, I trusted more experienced kernel developer's opinion
on this one.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
