Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab0KOTjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:39:07 -0500
Received: from claw.goop.org ([74.207.240.146]:56056 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab0KOTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:39:05 -0500
Message-ID: <4CE18C57.9070805@goop.org>
Date: Mon, 15 Nov 2010 11:39:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/20] x86/ticketlock: make __ticket_spin_trylock common
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>	 <4cea7b0804de5a2c1249034fc5c4840ade043ff4.1288794124.git.jeremy.fitzhardinge@citrix.com>	 <20101113101732.GH3837@hack> <1289645321.2743.21.camel@edumazet-laptop>
In-Reply-To: <1289645321.2743.21.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 02:48 AM, Eric Dumazet wrote:
> Le samedi 13 novembre 2010 à 18:17 +0800, Américo Wang a écrit :
>> On Wed, Nov 03, 2010 at 10:59:47AM -0400, Jeremy Fitzhardinge wrote:
>>
>>> +	union {
>>> +		struct __raw_tickets tickets;
>>> +		__ticketpair_t slock;
>>> +	} tmp, new;
>>> +	int ret;
>>> +
>>> +	tmp.tickets = ACCESS_ONCE(lock->tickets);
>>> +	if (tmp.tickets.head != tmp.tickets.tail)
>>> +		return 0;
>>> +
>>> +	new.slock = tmp.slock + (1 << TICKET_SHIFT);
>>> +
>>> +	ret = cmpxchg(&lock->ticketpair, tmp.slock, new.slock) == tmp.slock;
>>> +	barrier();		/* just make nothing creeps before lock is claimed */
>> This one should be smp_wmb(), right? No CONFIG_X86_OOSTORE protected.
> cmpxchg() is a full memory barrier, no need for smp_wmb() or barrier()

Agreed.

    J
