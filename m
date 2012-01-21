Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2AUToj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:44:39 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36195 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751015Ab2AUTog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:44:36 -0500
Message-ID: <4F1B2356.4040302@xenotime.net>
Date: Sat, 21 Jan 2012 12:43:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] idr: make idr_get_next() good for rcu_read_lock()
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LSU.2.00.1201191235330.29542@eggly.anvils> <alpine.LSU.2.00.1201191247210.29542@eggly.anvils> <20120120154807.c55c9ac7.akpm@linux-foundation.org> <alpine.LSU.2.00.1201201922110.1396@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1201201922110.1396@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 07:45 PM, Hugh Dickins wrote:
> On Fri, 20 Jan 2012, Andrew Morton wrote:
>> On Thu, 19 Jan 2012 12:48:48 -0800 (PST)
>> Hugh Dickins <hughd@google.com> wrote:
>>> Copied comment on RCU locking from idr_find().
>>>
>>> + *
>>> + * This function can be called under rcu_read_lock(), given that the leaf
>>> + * pointers lifetimes are correctly managed.
>>
>> Awkward comment.  It translates to "..., because the leaf pointers
>> lifetimes are correctly managed".
>>
>> Is that what we really meant?  Or did we mean "..., provided the leaf
>> pointers lifetimes are correctly managed"?
> 
> You are right, and part of me realized that even as I copied in the
> comment.  I wanted to express the same optimism for idr_get_next() 
> as was already expressed for idr_find() - whatever it meant ;)
> 
> I thought it was meaning a bit of both: idr.c is managing its end well
> enough that rcu_read_lock() can now be used, but the caller has to
> manage their locking and lifetimes appropriately too.
> 
>>
>> Also, "pointers" should have been "pointer" or "pointer's"!
> 
> You're afraid of Linus turning his "its/it's" wrath from Al to yourself.
> 
> Since "lifetimes" is in the plural, I think it would have to be
> "pointers'" - I _think_ that's correct, rather than "pointers's".

That seems correct to me also.

> But then, it's not the lifetimes of the pointers, but the lifetimes
> of the objects that they point to, that's in question.  So what it
> ought to say is...
> 
> ... falls asleep.

ack.

and thanks for doing all of that radix tree test harness work, Hugh.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
