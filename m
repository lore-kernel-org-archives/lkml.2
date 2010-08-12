Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0HLQFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:05:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759Ab0HLQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
 <1274733081-4623-7-git-send-email-walken@google.com> <AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
 <AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com> <AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 08:57:20 -0700
Message-ID: <AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
To: Michel Lespinasse <walken@google.com>
Cc: Tony Luck <tony.luck@intel.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:09 PM, Michel Lespinasse <walken@google.com> wrote:
> On Wed, Aug 11, 2010 at 10:02 PM, Michel Lespinasse <walken@google.com> wrote:
>> In arch/ia64/include/asm/rwsem.h I see RWSEM_WAITING_BIAS defined as
>> -__IA64_UL_CONST(0x0000000100000000)
>>
>> This makes it a large, positive unsigned value. This is probably
>> throwing off the rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS
>> comparison in my patch (supposed to be long versus long, but actually
>> is long versus unsigned long on ia64).
>
> FYI, I just verified that RWSEM_WAITING_BIAS is defined as signed on
> all architectures except for ia64. So, this would be consistent with
> the issue being observed only on ia64.

Good.

Tony, can you verify that just dropping the "__IA64_UL_CONST" makes
things work for you? Having a non-working rwsem makes me really
nervous, but considering the lack of reports on other architectures, I
really do hope this is just a trivial ia64 signedness difference.

                              Linus
