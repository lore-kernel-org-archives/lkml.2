Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab0KQIw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:52:27 -0500
Received: from claw.goop.org ([74.207.240.146]:36918 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab0KQIw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:52:26 -0500
Message-ID: <4CE397C8.9040901@goop.org>
Date: Wed, 17 Nov 2010 00:52:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Eric Dumazet <dada1@cosmosbay.com>, xiyou.wangcong@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <4CE3A1060200007800022B04@vpn.id2.novell.com>
In-Reply-To: <4CE3A1060200007800022B04@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:31 AM, Jan Beulich wrote:
>>>> On 16.11.10 at 22:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> +static inline void __ticket_enter_slowpath(struct arch_spinlock *lock)
>> +{
>> +	if (sizeof(lock->tickets.tail) == sizeof(u8))
>> +		asm (LOCK_PREFIX "orb %1, %0"
>> +		     : "+m" (lock->tickets.tail)
>> +		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
>> +	else
>> +		asm (LOCK_PREFIX "orw %1, %0"
>> +		     : "+m" (lock->tickets.tail)
>> +		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
>> +}
> Came only now to mind: Here and elsewhere, did you try using
> %z0 to have gcc produce the opcode suffix character, rather
> than having these somewhat ugly if()-s?

Actually in this case I'm pretty sure there's already a "set bit"
function which will do the job.  set_bit(), I guess, though it takes a
bit number rather than a mask...

But, yes, %z0 sounds interesting.  Is it documented anywhere?  I think
I've tried to use it in the past and run into gcc bugs.

Thanks,
    J
