Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1IIQWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:22:54 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:34320 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1IIQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:22:53 -0400
Message-ID: <1d564f4f4bec21945a4577fa0d84dc2e.squirrel@webmail.greenhost.nl>
In-Reply-To: <1315573084.4127.6.camel@dhcp-25-63.brq.redhat.com>
References: <201109090822.30063.vda.linux@googlemail.com>
    <201109090824.37366.vda.linux@googlemail.com>
    <2d14558326f860dea54093d31d1ba12f.squirrel@webmail.greenhost.nl>
    <1315573084.4127.6.camel@dhcp-25-63.brq.redhat.com>
Date: Fri, 9 Sep 2011 18:22:49 +0200
Subject: Re: [PATCH 1/2] ptrace: don't modify flags on PTRACE_SETOPTIONS
 failure
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 8b3222cd26cce149ddb9ffa05c4da76e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, September 9, 2011 14:58, Denys Vlasenko wrote:
> On Fri, 2011-09-09 at 14:44 +0200, Indan Zupancic wrote:
>> Hello,
>>
>> On Fri, September 9, 2011 08:24, Denys Vlasenko wrote:
>> > It's very unlikely that there is userspace code in the wild which
>> > will be affected by this change: it should have the form
>> >
>> >     ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)
>> >
>> > where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
>> > But kernel headers, naturally, don't contain any
>> > PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
>> > if it defines one itself. I can't see why anyone would do such
>> > a thing deliberately.
>>
>> The only realistic case is when a program compiled on a newer
>> kernel is run on an older kernel, when it does things like
>>
>> #ifndef PTRACE_O_TRACEFORK
>> 	opts |= PTRACE_O_TRACEFORK;
>> #endif
>>
>> and happened to work on older kernels because it didn't check
>> the return value.
>
> Well, older kernels, of course, will have *old* behavior
> of SETOPTIONS too! My patch will not magically propagate
> back in time and change behavior of old kernels :)

In that case your patch should be allowed to magically propagate
forward in time and change the behavior of future kernels.

Greetings,

Indan


