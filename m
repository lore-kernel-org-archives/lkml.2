Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0IURgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:36:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44686 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IURgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:36:05 -0400
Message-ID: <140ee1c060f22286fe2f4d81170f76be.squirrel@www.firstfloor.org>
In-Reply-To: <1285082049.23122.1930.camel@gandalf.stny.rr.com>
References: <cover.1284733808.git.jbaron@redhat.com>
    <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
    <20100921131232.GA3024@one.firstfloor.org>
    <20100921143555.GA2873@redhat.com>
    <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
    <1285082049.23122.1930.camel@gandalf.stny.rr.com>
Date: Tue, 21 Sep 2010 19:36:00 +0200
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

> On Tue, 2010-09-21 at 16:41 +0200, Andi Kleen wrote:
>> >
>> > So there are ~150 tracepoints, but this code is also being proposed
>> for
>> > use with 'dynamic debug' of which there are > 1000, and I'm hoping for
>> > more users moving forward.
>>
>> Even 1000 is fine to walk, but if it was sorted a binary search
>> would be much faster anyways. That is then you would still
>> need to search for each module, but that is a relatively small
>> number (< 100)
>
> xfs has > 100 tracepoints

Doesn
>
>>
>> > Also, I think the hash table deals nicely with modules.
>>
>> Maybe but it's also a lot of code. And it seems to me
>> that it is optimizing the wrong thing. Simpler is nicer.
>
> I guess simplicity is in the eye of the beholder. I find hashes easier
> to deal with than binary searching sorted lists. Every time you add a
> tracepoint, you need to resort the list.

The only time you add one is when you load a module, right? When you do
that you only sort the section of the new module.

> Hashes are much easier to deal with and scale nicely. I don't think
> there's enough rational to switch this to a binary list.

Well problem is that the code is very complicated today. I suspect
this could be done much simpler if it wasn't so overengin

-Andi


