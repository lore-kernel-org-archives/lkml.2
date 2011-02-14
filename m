Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1BNWcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:32:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58699
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab1BNWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:32:31 -0500
Date: Mon, 14 Feb 2011 14:33:06 -0800 (PST)
Message-Id: <20110214.143306.193725652.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297722030.23343.86.camel@gandalf.stny.rr.com>
References: <1297719576.23343.80.camel@gandalf.stny.rr.com>
	<20110214.134600.179933733.davem@davemloft.net>
	<1297722030.23343.86.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 14 Feb 2011 17:20:30 -0500

> On Mon, 2011-02-14 at 13:46 -0800, David Miller wrote:
>> From: Steven Rostedt <rostedt@goodmis.org>
>> Date: Mon, 14 Feb 2011 16:39:36 -0500
>> 
>> > Thus it is not about global, as global is updated by normal means and
>> > will update the caches. atomic_t is updated via the ll/sc that ignores
>> > the cache and causes all this to break down. IOW... broken hardware ;)
>> 
>> I don't see how cache coherency can possibly work if the hardware
>> behaves this way.
>> 
>> In cache aliasing situations, yes I can understand a L1 cache visibility
>> issue being present, but with kernel only stuff that should never happen
>> otherwise we have a bug in the arch cache flushing support.
> 
> I guess the issue is, if you use ll/sc on memory, you must always use
> ll/sc on that memory, otherwise any normal read won't read the proper
> cache.

That also makes no sense at all.

Any update to the L2 cache must be snooped by the L1 cache and cause
an update, otherwise nothing can work correctly.

So every object we use cmpxchg() on in the kernel cannot work on this
architecture?  Is that what you're saying?

If so, a lot of things we do will not work.
.
