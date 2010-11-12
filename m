Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0KLQ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:27:09 -0500
Received: from claw.goop.org ([74.207.240.146]:48626 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0KLQ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:27:08 -0500
Message-ID: <4CDD6AD8.5030003@goop.org>
Date: Fri, 12 Nov 2010 08:27:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 04/20] x86/ticketlock: make large and small ticket versions
 of spin_lock the same
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <5b3cbff3a6e96a085651f140a0525be80a4df8ba.1288794124.git.jeremy.fitzhardinge@citrix.com> <20101112121932.GA30016@linux.vnet.ibm.com>
In-Reply-To: <20101112121932.GA30016@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 04:19 AM, Srivatsa Vaddagiri wrote:
> On Wed, Nov 03, 2010 at 10:59:45AM -0400, Jeremy Fitzhardinge wrote:
>> Make the bulk of __ticket_spin_lock look identical for large and small
>> number of cpus.
> [snip]
>
>>  #if (NR_CPUS < 256)
>>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>  {
>> -	register union {
>> -		struct __raw_tickets tickets;
>> -		unsigned short slock;
>> -	} inc = { .slock = 1 << TICKET_SHIFT };
>> +	register struct __raw_tickets inc = { .tail = 1 };
> [snip]
>
>>  #else
>>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>  {
>> -	unsigned inc = 1 << TICKET_SHIFT;
>> -	__ticket_t tmp;
>> +	register struct __raw_tickets inc = { .tickets.tail = 1 };
> s/.tickets//?
>
> Otherwise I get a compile error for NR_CPUS > 256, with just 4 patches applied.

Yeah, likely.  That's precisely why I wanted to make them the same ;).

    J
