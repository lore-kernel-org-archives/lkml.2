Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0KPQjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:39:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab0KPQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <1289908158.2109.568.camel@laptop>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com> <1289908158.2109.568.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 08:38:05 -0800
Message-ID: <AANLkTime3Sh2TbgCGKir=t_TBNsd5fHipEqQwa4bVJuY@mail.gmail.com>
Subject: Re: [PATCH -v4 0/2] Lockless memory allocator and list
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 3:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-11-16 at 08:53 +0800, Huang Ying wrote:
>> Hi, Len,
>>
>> This patchset is needed by APEI support. Which involves some lockless
>> operations. And I think they can be used by some other part of kernel
>> too.
>
> The whole notion of allocating memory from NMI context seems incredibly
> offensive.
>
> And then there's the whole point of not merging stuff without a user.

So I do agree that people should look very hard at trying to use
existing infrastructure.

I kind of like the lock-less list implementation (it could easily be
useful for random things, and it's very simple). And I don't think the
notion of a lockless memory allocator is wrong either, although it
looks a lot more specialized than the list thing (the solution to
lockless allocations is generally simply to do them ahead of time).

So the part I'm really not all that comfy with is the whole APEI side
of things. I'm not at all convinced that we want yet another random
hw-specific interface, and I really have yet to hear why it's so
magical.

                          Linus
