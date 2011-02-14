Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1BNWiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:38:21 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:33202 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab1BNWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:38:18 -0500
Date: Mon, 14 Feb 2011 22:37:55 +0000
From: Matt Fleming <matt@console-pimps.org>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, peterz@infradead.org, will.newton@gmail.com,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110214.134600.179933733.davem@davemloft.net>
References: <1297707868.5226.189.camel@laptop>
 <1297718964.23343.75.camel@gandalf.stny.rr.com>
 <1297719576.23343.80.camel@gandalf.stny.rr.com>
 <20110214.134600.179933733.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 13:46:00 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 14 Feb 2011 16:39:36 -0500
> 
> > Thus it is not about global, as global is updated by normal means
> > and will update the caches. atomic_t is updated via the ll/sc that
> > ignores the cache and causes all this to break down. IOW... broken
> > hardware ;)
> 
> I don't see how cache coherency can possibly work if the hardware
> behaves this way.

Cache coherency is still maintained provided writes/reads both go
through the cache ;-)

The problem is that for read-modify-write operations the arbitration
logic that decides who "wins" and is allowed to actually perform the
write, assuming two or more CPUs are competing for a single memory
address, is not implemented in the cache controller, I think. I'm not a
hardware engineer and I never understood how the arbitration logic
worked but I'm guessing that's the reason that the ll/sc instructions
bypass the cache.

Which is why the atomic_t functions worked out really well for that
arch, such that any accesses to an atomic_t * had to go through the
wrapper functions.
