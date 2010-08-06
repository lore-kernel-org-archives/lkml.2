Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046Ab0HFUDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:03:08 -0400
Received: from claw.goop.org ([74.207.240.146]:56846 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934215Ab0HFUDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:03:02 -0400
Message-ID: <4C5C6A74.1050106@goop.org>
Date: Fri, 06 Aug 2010 13:03:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [PATCH RFC 03/12] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <f3622d39ae72573c586405ea6f1597eb39fc28d4.1279328276.git.jeremy.fitzhardinge@citrix.com> <20100720153845.GA9122@phenom.dumpdata.com> <4C45CC02.7030603@goop.org> <4C5C4AAB.3000606@zytor.com>
In-Reply-To: <4C5C4AAB.3000606@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/06/2010 10:47 AM, H. Peter Anvin wrote:
> On 07/20/2010 09:17 AM, Jeremy Fitzhardinge wrote:
>> "volatile" would be a compiler barrier, but it has no direct effect on,
>> or relevence to, the CPU.  It just cares about the LOCK_PREFIX.  The
>> "memory" clobber is probably unnecessary as well, since the constraints
>> already tell the compiler the most important information.  We can add
>> barriers separately as needed.
>>
> You absolutely need volatile, since otherwise you're permitting the
> compiler to split, re-execute or even drop the code.  Anything else
> might work, by accident, but it's not clean.

I don't think so in this case.  The instructions in question are 
basically lock->waiters++/--; the only reason they need to be asm is 
that they're locked.  But I'm not relying on them for any kind of 
compiler or cpu ordering or barrier.  Where ordering is important, I 
have explicit barrier()s to enforce it.

     J
