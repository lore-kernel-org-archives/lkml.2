Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0IURjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:39:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44706 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0IURjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:39:05 -0400
Message-ID: <04c02fdea99c71ad5f166152c9331f2d.squirrel@www.firstfloor.org>
In-Reply-To: <1285082049.23122.1930.camel@gandalf.stny.rr.com>
References: <cover.1284733808.git.jbaron@redhat.com>
    <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
    <20100921131232.GA3024@one.firstfloor.org>
    <20100921143555.GA2873@redhat.com>
    <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
    <1285082049.23122.1930.camel@gandalf.stny.rr.com>
Date: Tue, 21 Sep 2010 19:39:04 +0200
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


>> Even 1000 is fine to walk, but if it was sorted a binary search
>> would be much faster anyways. That is then you would still
>> need to search for each module, but that is a relatively small
>> number (< 100)
>
> xfs has > 100 tracepoints

No problem for binary search.

>> > Also, I think the hash table deals nicely with modules.
>>
>> Maybe but it's also a lot of code. And it seems to me
>> that it is optimizing the wrong thing. Simpler is nicer.
>
> I guess simplicity is in the eye of the beholder. I find hashes easier
> to deal with than binary searching sorted lists. Every time you add a
> tracepoint, you need to resort the list.

You only add trace points with new modules right?
In this case you only sort the section of the new module, nothing else.
And only once when you load it.

> Hashes are much easier to deal with and scale nicely. I don't think
> there's enough rational to switch this to a binary list.

The problem I see is that there's a lot of hashing related code
and a lot of memory overhead. I suspect with inplace access
everything would be much simpler and less overhead.

For me the current implementation simply seems overengineered.

-Andi

