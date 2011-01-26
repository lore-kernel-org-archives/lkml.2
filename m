Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1AZSLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1AZSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:11:53 -0500
Message-ID: <4D405A9D.4070607@redhat.com>
Date: Wed, 26 Jan 2011 15:32:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com>
In-Reply-To: <4D403855.4050706@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-01-2011 13:05, Mark Lord escreveu:
> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
>> On Tue, Jan 25, 2011 at 03:29:14PM -0800, Dmitry Torokhov wrote:
>>> On Tue, Jan 25, 2011 at 05:22:09PM -0500, Mark Lord wrote:
>>>> On 11-01-25 05:00 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
> ..
>>>>>> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
>>>>
>>>> That's the problem: you did NOT keep the two old ioctls().
>>>> Those got changed too.. so now we have four NEW ioctls(),
>>>> none of which backward compatible with userspace.
>>>>
>>>
>>> Please calm down. This, in fact, is not new vs old ioctl problem but
>>> rather particular driver (or rather set of drivers) implementation
>>> issue. Even if we drop the new ioctls and convert the RC code to use the
>>> old ones you'd be observing the same breakage as RC code responds with
>>> -EINVAL to not-yet-established mappings.
>>>
>>> I'll see what can be done for these drivers; I guess we could supply a
>>> fake KEY_RESERVED entry for not mapped scancodes if there are mapped
>>> scancodes "above" current one. That should result in the same behavior
>>> for RCs as before.
>>>
>>
>> I wonder if the patch below is all that is needed...
> 
> 
> Nope. Does not work here:
> 
> $ lsinput
> protocol version mismatch (expected 65536, got 65537)

You need to relax the version test at the tree. As I said before, this is
a development tool from the early RC days, bound to work with one specific
version of the API, and programmed by purpose to fail if there would by any
updates at the Input layer.

Cheers,
Mauro.
