Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0IUSsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:48:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0IUSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:48:34 -0400
Message-ID: <6ed1e9d88b6bce14f715416f5e801780.squirrel@www.firstfloor.org>
In-Reply-To: <1285092337.26872.12.camel@gandalf.stny.rr.com>
References: <cover.1284733808.git.jbaron@redhat.com>
    <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
    <20100921131232.GA3024@one.firstfloor.org>
    <20100921143555.GA2873@redhat.com>
    <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
    <1285082049.23122.1930.camel@gandalf.stny.rr.com>
    <140ee1c060f22286fe2f4d81170f76be.squirrel@www.firstfloor.org>
    <1285092337.26872.12.camel@gandalf.stny.rr.com>
Date: Tue, 21 Sep 2010 20:48:28 +0200
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: "Andi Kleen" <andi@firstfloor.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jason Baron" <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Doesn
>
> I suppose you were missing a 't'.

Sorry sentence was eaten (I had to type it twice because the webmail
thingy eat it first try and probably didn't finish
it second time). I did not doubt your trace point number :)

What I meant is that the number of trace points does not really
matter much for binary search, unless you're going to gigantic numbers.
100 is still searched in only a few tries.

What matters is just how many tables you need to walk and that
only scales with the number of modules, not the number of trace points.

for ( each module )
    binary search in section

Advantage: no additional memory, no setup code other than a simple
sort, less code overall.

Also most modules are small so a binary search try is likely very
fast.

The methology is also long proven for *_user() exception handling
and always worked well here.

>> The only time you add one is when you load a module, right? When you do
>> that you only sort the section of the new module.
>
> And on removing a module.

On removing you simply free the module table, no real work to do.

> Perhaps it can be cleaned up. But I have no issues with it now, and
> using a hash (basic data structures 101) is not where the complexity
> comes in.

Hash tables are not complex in themselves, but all the code to
maintain them still adds up. I think considerable parts of the
new code were simply that. IMHO that can be done simpler
at no real loss of functionality or performance.

-Andi

