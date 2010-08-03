Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab0HCUcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:32:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726Ab0HCUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100803194553.GA27688@Krystal>
References: <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> 
	<20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> 
	<20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> 
	<20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> 
	<1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> 
	<20100803194553.GA27688@Krystal>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Aug 2010 13:02:59 -0700
Message-ID: <AANLkTinW34tSZ0gLyRb4mjh1UX4w=34pNcjU=fY+y_oT@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 12:45 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> The real issue here, IMHO, is that Perf has tied gory ring buffer implementation
> details to the userspace perf ABI, and there is now strong unwillingness from
> Perf developers to break this ABI.

The thing is - I think my outlined buffer fragmentation model would
work fine with the perf ABI too.  Exactly because there is no deep
structure, just the same "stream of small events" both from a kernel
and a user model standpoint. Sure, the stream would now contain a new
event type, but that's trivial. It would still be _entirely_
reasonable to have the actual data in the exact same ring buffer,
including the whole mmap'ed area.

Of course, when user space actually parses it, user space would have
to eventually defragment the event by allocating a new area and
copying the fragments together in the right order, but that's pretty
trivial to do. It certainly doesn't affect the current mmap'ed
interface in the least.

Now, whether the perf people feel they want that kind of
functionality, I don't know. It's possible that they simply do not
want to handle events that are complex enough that they would have
arbitrary size.

                   Linus
