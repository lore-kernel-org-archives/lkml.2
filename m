Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937595Ab0CPJGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:06:32 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36816 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937587Ab0CPJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N9YxVOZSjApMEsV0TNaFQniCoi+/PAvM3mici7VTYOMfLEA4rTZo/yr4F2UZ7AA2xE
         5lqzfbomWamqH+MS9UEoN/dj9PnfNzAhvmML8F4tJ8kKvyU9z+AWnfM8CblukurQ2oyL
         g3IhYl1W+9sqUZ1+vw4zfQkgY9F6ygzbpA9t4=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1003160123k5876f092s9dab18862713c127@mail.gmail.com>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu>
	 <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
	 <b6fcc0a1003160015j2926b2a2w4e7808939c4144d6@mail.gmail.com>
	 <4B9F39BE.40502@cs.helsinki.fi>
	 <b6fcc0a1003160123k5876f092s9dab18862713c127@mail.gmail.com>
Date: Tue, 16 Mar 2010 11:06:27 +0200
X-Google-Sender-Auth: a3827f92ed91a868
Message-ID: <84144f021003160206l7c8895aby5e54d0b54c3bd8eb@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 10:23 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Mar 16, 2010 at 9:56 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Alexey Dobriyan kirjoitti:
>>>
>>> On Tue, Mar 16, 2010 at 8:58 AM, Pekka Enberg <penberg@cs.helsinki.fi>
>>> wrote:
>>>>
>>>> We should avoid creating tree-wide breakage for this kind of cleanups.
>>>
>>> This is done by compile testing, not by being smartass.
>>
>> I don't think compile testing is going to scale here because slab is used is
>> so many places of the kernel.
>
> Sigh.
>
> If you want to skip compile testing, just say so in changelog.

Hey, "sigh" right back at you, Alexey!

I am not saying I want to skip "compile testing", I'm just stating the
obvious fact: for a header such as slab.h that's implicitly needed in
pretty much everywhere, it's very difficult to find all the relevant
broken configurations. I don't see the benefit of breaking the world
for this cleanup as Ingo's suggestion will eventually get us to the
exact same situation _without_ causing tree-wide breakage.

                        Pekka
