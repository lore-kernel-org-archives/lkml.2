Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1BNXUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:20:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38921 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1BNXUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:20:50 -0500
Message-ID: <4D59B891.8010300@zytor.com>
Date: Mon, 14 Feb 2011 15:19:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop> <1297718964.23343.75.camel@gandalf.stny.rr.com> <1297719576.23343.80.camel@gandalf.stny.rr.com> <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 02:37 PM, Matt Fleming wrote:
>>
>> I don't see how cache coherency can possibly work if the hardware
>> behaves this way.
> 
> Cache coherency is still maintained provided writes/reads both go
> through the cache ;-)
> 
> The problem is that for read-modify-write operations the arbitration
> logic that decides who "wins" and is allowed to actually perform the
> write, assuming two or more CPUs are competing for a single memory
> address, is not implemented in the cache controller, I think. I'm not a
> hardware engineer and I never understood how the arbitration logic
> worked but I'm guessing that's the reason that the ll/sc instructions
> bypass the cache.
> 
> Which is why the atomic_t functions worked out really well for that
> arch, such that any accesses to an atomic_t * had to go through the
> wrapper functions.

I'm sorry... this doesn't compute.  Either reads can work normally (go
through the cache) in which case atomic_read() can simply be a read or
they don't, so I don't understand this at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

