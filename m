Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1BIT4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:56:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:31376 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1BIT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:56:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ggfpCVNht8nxCD4usYSQF6WIezbzqDuYgRSSzaw/M5GAE8OtbxTXTLArXTUuM5jwkc
         g29wHFqiuLLuR7ZMVL9Q==
From: Ian Lance Taylor <iant@google.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Martin Capitanio <m@capitanio.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Russ Cox <rsc@golang.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
Subject: Re: [golang-dev] Re: mmap, the language go, problems with the linux kernel
References: <1297168678.2190.21.camel@marvin>
	<AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
	<1297269019.4888.91.camel@marvin> <20110209191755.GE9533@thunk.org>
Date: Wed, 09 Feb 2011 11:56:13 -0800
In-Reply-To: <20110209191755.GE9533@thunk.org> (Ted Ts'o's message of "Wed, 9
	Feb 2011 14:17:55 -0500")
Message-ID: <mcrei7hnfs2.fsf@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ted Ts'o" <tytso@mit.edu> writes:

> Linux has interpreted it to mean "virtual address space", and in fact
> it's documented as such in the its version of the getrlimit man page.
> I'd have to agree with Linus that it's probably way too late to change
> what it means (or what Linux thinks it means, anyway).

I don't think anybody seriously expects Linux to change the meaning of
ulimit -v at this point.  Obviously Go is going to do something
different here.

However, I think it's still worth pointing out that while ulimit -v no
doubt has specialized applications, it does not do exactly what I think
most people want.  I think most people want some way to say "do not let
this program cause my machine to start thrashing."  That's what I use
ulimit -v for; if I don't, a program which accidentally allocates memory
in an endless loop starts thrashing.  But I don't actually care how much
virtual memory the program is using; what I care about is limiting the
amount of physical memory it is using, so that it doesn't take over my
machine.

I think that would be a useful feature to implement regardless of how we
feel about ulimit -v and Go.  I think we can reasonably expect more and
more programs to try to advantage of large virtual address spaces.  Lets
have a way to use them while still having a way to keep them from
thrashing.

Ian
