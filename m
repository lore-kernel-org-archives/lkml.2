Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0FJFzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:55:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FJFzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:55:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=kTVZHdjSi6yJBTW6c2xqXU/g0A+E7En5TIVFjPwfcMv01GKp9IwcgjPNKI2muYZHj
	izBHcpKanmUIKBOtgu2hA==
MIME-Version: 1.0
In-Reply-To: <AANLkTilXJ0X2qxD9cNTlLayKzySEZu1HEZUWu--Go8kw@mail.gmail.com>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>
	<alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org>
	<1276119207.1745.154.camel@laptop>
	<alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org>
	<AANLkTim56xHJM-6ZgFvEO2YetDLCnjaCoOtxYGTqtE0c@mail.gmail.com>
	<alpine.LFD.2.00.1006091719100.4506@i5.linux-foundation.org>
	<AANLkTilXJ0X2qxD9cNTlLayKzySEZu1HEZUWu--Go8kw@mail.gmail.com>
Date: Wed, 9 Jun 2010 22:55:13 -0700
Message-ID: <AANLkTikK9m7USWqN9QZnjnNbHen9bVyFt6xiGxNG4OyY@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Salman Qazi <sqazi@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tytso@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 10:17 PM, Michel Lespinasse <walken@google.com> wrote:
> On Wed, Jun 9, 2010 at 5:20 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Wed, 9 Jun 2010, Salman Qazi wrote:
>> >
>> > I don't think this gives the right answer in the a < base < b  case.
>> > Here a - base < 0 and
>> > b - base > 0.  But we really want b to be before a, since a has rolled
>> > over further than b.
>>
>> Right you are.
>>
>> > I think the right solution is comparing (a - base + max_pid) % max_pid
>> > with (b - base + max_pid) % max_pid.  Am I correct or deluded? .
>>
>> That would work, but it would be horrible. Just use the three compares
>> version: doing a integer 'mod' operator is _way_ more expensive.
>
> As shown by the three compares version, the question here does not depend on
> the max_pid value. So, we can replace max_pid with any integer >= max_pid
> without changing the result. This is nice because, replacing max_pid with
> 2^32, the expression simplifies to:
>
> (unsigned)(a - base) < (unsigned)(b - base)
>
> I think I like this form after all :)

I don't mind doing this, if nobody disagrees.  Should be fine with a
comment on top explaining the intention?

>
> --
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.
>
