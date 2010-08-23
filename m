Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0HWSnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:43:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55329 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab0HWSnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:43:14 -0400
Message-ID: <4C72C139.9090601@us.ibm.com>
Date: Mon, 23 Aug 2010 11:43:05 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com> <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain> <1282470917.11348.891.camel@localhost.localdomain> <20100822172548.GB8957@suse.de> <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com> <19570.38608.79434.179797@chiark.greenend.org.uk> <1282580751.2605.1997.camel@laptop> <19570.44367.719276.128881@chiark.greenend.org.uk> <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com> <1282586385.2605.2119.camel@laptop>
In-Reply-To: <1282586385.2605.2119.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 10:59 AM, Peter Zijlstra wrote:
> On Mon, 2010-08-23 at 10:34 -0700, Linus Torvalds wrote:
>> I suspect that if you use mlock for _any_ other reason than protecting
>> a particular very sensitive piece of information, you should use
>> mlockall(MCL_FUTURE). IOW, if you use mlock because you have realtime
>> issues, there is no excuse to ever use anything else, imho. And even
>> then, I guarantee that things like copy-on-write is going to be
>> "interesting".
>>
>> I realize that people hate mlockall() (and particularly MCL_FUTURE),
>> and yes, it's a bloated thing that you can't reasonably use on a large
>> process. But dammit, if you have RT issues, you shouldn't _have_ some
>> big bloated process. You should have a small statically linked server
>> that is RT, and nothing else.
>
> Us real-time people have been telling people to not use mlockall() at
> all.

Well, we have at least two camps of people here I guess. When people 
come to me with unexplainable latencies, paging is one of the things we 
check for, and mlockall() is a good way to test if avoiding that paging 
will help them - so I have been known to recommend it on occasion.

> While small !glibc statically linked RT components using shared memory
> interfaces to !RT apps could work its not how people actually write
> their apps. They write big monolithic threaded apps where some threads
> are RT.
>
> [ in part because there doesn't seem to be a usable !glibc
> libpthread/librt implementation out there, in part because people use
> crap like Java-RT ]

Which is also missing some performance and functionality due to the lack 
of complete pthread support for priority inheritance (and the complete 
disinterest in fixing it by certain maintainers).

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
