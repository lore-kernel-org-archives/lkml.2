Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1HXWig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:38:36 -0400
Received: from claw.goop.org ([74.207.240.146]:53846 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab1HXWie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:38:34 -0400
Message-ID: <4E555AD0.3020101@goop.org>
Date: Wed, 24 Aug 2011 13:10:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com>
In-Reply-To: <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 11:24 AM, Linus Torvalds wrote:
> On Wed, Aug 24, 2011 at 11:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> The patches look good to me, and 50 lines less is always nice too!
>>
>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> So I mostly agree, except for the abortion that is the
> __ticket_spin_unlock changes. Please just kill that part.

Could we just kill SMP support for OOSTORE machines now?  That would be
the cleanest possible fix...

> So I'd much have preferred that the xadd helper go in first (07/18),
> then the patch to make __ticket_spin_lock the same for 32/64 would go
> in next (04/18) using that helper, and then they'd just have been
> identical automatically.
>
> Instead, there are a few patches that actually make the code uglier
> temporarily, only to then be undone later. That seems bogus, when it
> looks so simple to fix it.

Yep, OK.  The current series is a history of incremental development; I
can easily clean it up into something that appeared perfectly formed.

    J
