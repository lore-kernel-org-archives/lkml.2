Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2A0Xwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:52:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51743 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2A0Xw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:52:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAN8TOE8Hq8f3ipQFxBAHXK5ArSH6wNc8GA5CbYr_xORBa5gAWw@mail.gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
	<1327674295-3700-2-git-send-email-akinobu.mita@gmail.com>
	<1327684589.12089.22.camel@joe2Laptop>
	<CAN8TOE8Hq8f3ipQFxBAHXK5ArSH6wNc8GA5CbYr_xORBa5gAWw@mail.gmail.com>
Date: Sat, 28 Jan 2012 08:52:25 +0900
Message-ID: <CAC5umyh6H-0JXyQ9V97FH_Cp7Y2swbRMJptXJwnE0cK6HqbkGQ@mail.gmail.com>
Subject: Re: [PATCH] mtd/nand: use string library
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Joe Perches <joe@perches.com>, Scott Branden <sbranden@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Jiandong Zheng <jdzheng@broadcom.com>, akpm@linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>, eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/28 Brian Norris <computersforpeace@gmail.com>:
> On Fri, Jan 27, 2012 at 9:16 AM, Joe Perches <joe@perches.com> wrote:
>> On Fri, 2012-01-27 at 23:24 +0900, Akinobu Mita wrote:
>>> - Use memchr_inv to check if the data contains all 0xFF bytes.
>>>   It is faster than looping for each byte.
>>
>> Stupid question:
>>
>> Are there any mtd devices modified that are slower
>> at 64 bit accesses than repeated 8 bit accesses?
>
> I believe this patch deals with kernel buffers, not any kind of direct
> access to the MTD, so the question (which is not stupid IMO) should be
> regarding CPU architectures. And my educated guess is that 64-bit
> access should not be any slower. I do know that 8-bit access *is*
> slower for some relevant architectures.

It could be slower when the number of bytes scanned is very small
(found a unmatched character immediately, or the size of the area
is very small), because memchr_inv() needs to generate a 64bit pattern
to compare before starting the loop.  I recalled that Eric Dumazet
pointed out it could generate the 64bit pattern more efficiently.
(https://lkml.org/lkml/2011/8/8/480)

Even if that small scanning is slower, this change can be assumed cleanup
patch that simplifies the code.
