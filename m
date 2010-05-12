Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0ELT7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:59:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55925 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0ELT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PEi51no4Nm2Wdt9QY2JaD4D/U+D46RudozkkGZrsav7hsyqwknlbYcL9NZnI30REWy
         34cOTav8uP1DBBloti0C7OT1UwGgmSRqhptlfhencylwnGKQ3PrwANGlZK28IlgCL/8b
         7rmMWjxW0vZQqs3KEIxBbpEaNgCJx2AJIL5CI=
MIME-Version: 1.0
In-Reply-To: <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
	 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
	 <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
	 <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
	 <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
Date: Wed, 12 May 2010 21:59:07 +0200
Message-ID: <AANLkTimxO3xWmr8jgyiwsLNyqTJ-4OWJ4zNROC9SE7XH@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 9:36 PM, Paul Menage <menage@google.com> wrote:
> On Wed, May 12, 2010 at 12:29 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>>> I think the idea is reasonable - the only way that I could see it
>>> breaking someone would be code that currently does something like:
>>>
>>> mkdir A
>>> mkdir B
>>> echo 1 > A/mem_exclusive
>>> echo 1 > B/mem_exclusive
>>> echo $mems_for_a > A/mems
>>> echo $mems_for_b > B/mems
>>>
>>> The attempts to set the mem_exclusive flags would fail, since A and B
>>> would both have all of the parent's mems.
>>>
>>
>> But would this not fail otherwise?
>>
>
> Assuming that mems_for_a and mems_for_b were disjoint, it would be
> fine currently.
>

Ah my bad. I misread mems_for_a as taking the value from the parent.
You are right, that was a case I missed.

Hmm, so how do we fix this? Any solutions? Not fixing the kernel
pushes the problem to the userspace, making it hard for tons of more
applications to use cgroups without jumping through a lot of hoops.

Dhaval
