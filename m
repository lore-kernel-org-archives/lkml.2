Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1J0DhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 23:37:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1J0DhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 23:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <CALyraeOO2DHrS1oh0FLG11XuxEvMzgJ+MRRrxwXx+vLTxbuDYg@mail.gmail.com>
References: <CALyraeOO2DHrS1oh0FLG11XuxEvMzgJ+MRRrxwXx+vLTxbuDYg@mail.gmail.com>
Date: Wed, 26 Oct 2011 20:37:11 -0700
Message-ID: <CABi1daE=Jgs=cLe+Zxp28oFhrguFYQKxfTc6agDxYfo=oA+d_A@mail.gmail.com>
Subject: Re: Question on Memory Leak: very tough problem
From: Dave Hylands <dhylands@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sri,

On Wed, Oct 26, 2011 at 8:20 PM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
>
> Hi All,
>
> I have very difficult problem I am working on to figure out where the
> memory leak is in my system. Sometimes it shows up and sometimes it
> reveals very slowly (I mean increments very slowly). This is dependent
> on system load, if the system is in very high load, then leak is very
> fast. We tried solving this problem from many dimensions, but no
> success.
>
> After quite sometime, we started using valgrind to capture the memory
> leak. The funny thing is the leak disappears once we start running our
> application on top of valgrind.
> So, we cannot capture leak using valgrind. We came to conclusion that,
> since valgrind serializes the allocations (leak disappears), we
> thought this might be result of race conditions, that
> resulted from system high load (by the way ours is multi threaded
> system). We run system without valgrind we see the memory leak.
>
> The question is, is it true that valgrind serializes the mem
> allocations. Does this happen to anyone disappearing the leak when
> used valgrind.
>
> Any thoughts and input that can help me solve this problem. Thanks to
> all in advance.

A couple of possibilities spring to mind.

It might be that the leak is being caused by some uninitialized
variables/memory. Running under valgrind may be causing the
unitialized variables to change, which in turn causes the behavior to
change.

It also may be that you don't have a leak, but in fact have heap
fragmentation, which can look like a leak.

--
Dave Hylands
Shuswap, BC, Canada
http://www.davehylands.com
