Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1FRSvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:51:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54010 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1FRSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110618193340.53811cbe@lxorguk.ukuu.org.uk>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
	<BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
	<20110618193340.53811cbe@lxorguk.ukuu.org.uk>
Date: Sat, 18 Jun 2011 11:51:38 -0700
Message-ID: <BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
Subject: Re: Does Linux select() violate POSIX?
From: Nemo Publius <nemo@self-evident.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 11:33 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> This is simply not true for any POSIX-compliant operating system.
>> Which in this case happens to include every Unix ever written since
>> the beginning of time, apart from Linux.
>
> Actually no - there are lots of device cases where instantaneously it is
> true that a read would not block but the condition then changes again.

Well, not to be contentious, but...  Can you identify any Unix other
than Linux where this is allowed to happen?  I am pretty sure BSD (for
example) takes pains to avoid it.

> An obvious simple example beyond that is a socket with two readers.

With any "test something, then assume result of test" sequence,
obviously I can have race conditions with multiple processes or
threads.  I mean, had I asked, "I call write() and then lseek() to
where I started and then read() on a file; am I guaranteed to read
back what I wrote?"  And you said no, because some other process could
write in the meantime...  I would say that is technically true but not
at all what I was asking.

This is the same thing.  Of course I am talking about select()
followed by recv() without any intervening user-space operations on
the descriptor.

> Linux follows Posix generally, but nobody writes portable code that does
> blocking reads on a poll/select interface because there are a bazillion
> ways it can then block - events read by other tasks, discards due to
> memory exhaustion, events that are cleared the other end, etc.

Only if I wrote my program that way...  Or if I am running on Linux.

> It's a design decision and a huge performance win. It's one of the areas
> where POSIX read in its strictest form cripples your performance.

A fair answer.  :-)

So in short, Linux deliberately chooses non-compliance here because
(a) it is a "huge performance win" and (b) there is an easy
work-around that (c) you usually want to be doing anyway.  That
answers my question.

Thank you for taking the time to reply, Alan.  I was hoping for an
"authoritative" response, and yours certainly qualifies.
