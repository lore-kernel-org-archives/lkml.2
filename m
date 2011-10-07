Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab1JGEAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:00:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:51226 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1JGEA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:00:29 -0400
Date: Thu, 6 Oct 2011 21:00:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyclonus J <cyclonusj@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: intercommunications between Linux kernel modules
In-Reply-To: <CAOzbF4d+4cZNu_jTPuWcxves2QvidczcfzMzspMKYkGHi-mFxA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1110062056490.5597@asgard.lang.hm>
References: <CAOzbF4dvtM5WJ9-LkP4tFROA_gnT-gh-+-3qJLSqtUKOp0SvMg@mail.gmail.com> <m28vox36cm.fsf@firstfloor.org> <CAOzbF4d+4cZNu_jTPuWcxves2QvidczcfzMzspMKYkGHi-mFxA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Cyclonus J wrote:

> On Thu, Oct 6, 2011 at 7:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Cyclonus J <cyclonusj@gmail.com> writes:
>>
>>> I am looking for a way to do an IPC-like communications between two
>>> linux kernel modules, such as mqueue or shared memory. After searching
>>> for a while, I can't find such information available inside existing
>>> linux kernel or online.
>>>
>>> So, my question is if this is something discussed before here and gets
>>> rejected or still might be accepted in the mainstream kernel tree?
>>
>> All kernel memory is shared in Linux, so the concept doesn't make sense.
>>
>> If you want to send messages or communicate inside the kernel there are
>> lots of different facilities available.
>
> Andi,
>
> That would be great! Could you point me to some facilities that can do
> this message passing between kernels?

what you are missing is that there aren't two different kernels. it's one 
big process. think multi-threaded programming instead of inter-process 
communication. You don't even have well defined threads to work with so 
you can't say "I'm in thread 1 and need to communicate with thread 2", you 
need to think "I'm in this routine and I need to set a message in a way 
that another routine will read it", this can be as simple as just setting 
a variable (although you do need to make it the equivalent of 'thread 
safe' through appropriate locking or lock-free protection)

David Lang
