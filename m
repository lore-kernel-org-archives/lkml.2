Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0HPLbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab0HPLbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:31:06 -0400
Message-ID: <4C692129.4040307@redhat.com>
Date: Mon, 16 Aug 2010 14:29:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com> <4C6816BD.8060101@redhat.com> <20100815164413.GA9990@Krystal> <4C681B03.2050302@redhat.com> <20100815183121.GA6476@Krystal>
In-Reply-To: <20100815183121.GA6476@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/15/2010 09:31 PM, Mathieu Desnoyers wrote:
>
> I tested it in the past, and must admit that I changed from a vmalloc-based
> implementation to page-based using software cross-page write primitives based on
> feedback from Steven and Ingo. Diminishing TLB trashing seemed like a good
> approach, and using vmalloc on 32-bit machines is a pain, because users have to
> tweak the vmalloc region size at boot. So all in all, I moved to a vmalloc-less
> implementation without much more thought.


Forgot to comment about the i386 issue - that really is a blocker if you 
absolutely need to support large trace buffers on 32-bit machines.  I 
would urge all those people to move to x86_64 and be done with it, but I 
don't know all the use cases.

It's possible to hack this to work by having a private mm_struct and 
switching to it temporarily, but it will be horribly slow.

-- 
error compiling committee.c: too many arguments to function

