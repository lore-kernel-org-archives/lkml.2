Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab0FJQjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab0FJQjR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikK9m7USWqN9QZnjnNbHen9bVyFt6xiGxNG4OyY@mail.gmail.com>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>
	<alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org>
	<1276119207.1745.154.camel@laptop>
	<alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org>
	<AANLkTim56xHJM-6ZgFvEO2YetDLCnjaCoOtxYGTqtE0c@mail.gmail.com>
	<alpine.LFD.2.00.1006091719100.4506@i5.linux-foundation.org>
	<AANLkTilXJ0X2qxD9cNTlLayKzySEZu1HEZUWu--Go8kw@mail.gmail.com>
	<AANLkTikK9m7USWqN9QZnjnNbHen9bVyFt6xiGxNG4OyY@mail.gmail.com>
Date: Thu, 10 Jun 2010 09:39:02 -0700
Message-ID: <AANLkTikZx3sCFvCUWUwtMfRzMsnQ9E2UWs4XbfCw5XID@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Salman Qazi <sqazi@google.com>
Cc: Michel Lespinasse <walken@google.com>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tytso@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 10:55 PM, Salman Qazi <sqazi@google.com> wrote:
> On Wed, Jun 9, 2010 at 10:17 PM, Michel Lespinasse <walken@google.com> wrote:
>>
>> As shown by the three compares version, the question here does not depend on
>> the max_pid value. So, we can replace max_pid with any integer >= max_pid
>> without changing the result.

I like the logical argument, and cannot fault it.

>> This is nice because, replacing max_pid with
>> 2^32, the expression simplifies to:
>>
>> (unsigned)(a - base) < (unsigned)(b - base)
>>
>> I think I like this form after all :)

Sounds right to me.

> I don't mind doing this, if nobody disagrees.  Should be fine with a
> comment on top explaining the intention?

Yes. And lots of testing (including, very much, the whole max_pid
roll-over, of course). The logic of it all seems impeccable, but
nothing beats testing.

Thanks,
             Linus
