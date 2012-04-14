Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab2DNShX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:37:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35518 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2DNShW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <1334427139.2528.110.camel@twins>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
 <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
 <4F75BED4.9050005@linux.vnet.ibm.com> <1333118719.2960.27.camel@laptop>
 <4F76B7B9.5080709@linux.vnet.ibm.com> <1334395065.2528.43.camel@twins>
 <CA+1xoqe6UL36=F2mg8cYJsyW9_kxjmdX-H=khdKmbhg+mEpbmw@mail.gmail.com> <1334427139.2528.110.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 14 Apr 2012 20:37:01 +0200
Message-ID: <CA+1xoqf3z5w8R92OksA8KO1nu30r8gdoYOJR9W+gAgi7hZTDPg@mail.gmail.com>
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108 select_fallback_rq+0x241/0x280()
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 8:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2012-04-14 at 13:40 +0200, Sasha Levin wrote:
>> On Sat, Apr 14, 2012 at 11:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Sat, 2012-03-31 at 13:22 +0530, Srivatsa S. Bhat wrote:
>> >>
>> >> One of the perils of using macros instead of true function calls :-(
>> >>
>> > You can do type checking in macros too, its not pretty, but there's
>> > several such things already, see min()/max() for example.
>>
>> Would it make sense to somehow standardize type checking in kernel
>> macros? Possibly a set of wrappers that would make type checking easy
>> to get into new and existing macros?
>
>
> I had a quick go with the below and that doesn't quite work for no
> obvious reasons as of yet.. Also, that call out to cpumask_next() should
> already do type validation for us, so still no clue why my earlier code
> compiled at all.

I've also started working on it, I have something that looks pretty
good and detects the bug which has caused this discussion.

I want to apply it on several more macros around the kernel and I'll
send a RFC. Basically I want to deal with the cpumask thing, update
min()/max()/etc to use it and convert the list or rbtree macros to use
it as well. It'll give us a good look on how something like that would
look around the kernel.
