Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1HXVs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:48:58 -0400
Received: from claw.goop.org ([74.207.240.146]:53642 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1HXVs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:48:56 -0400
Message-ID: <4E5571C6.10704@goop.org>
Date: Wed, 24 Aug 2011 14:48:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com> <m2pqjud1fz.fsf@firstfloor.org> <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com> <20110824214334.GS25996@one.firstfloor.org>
In-Reply-To: <20110824214334.GS25996@one.firstfloor.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 02:43 PM, Andi Kleen wrote:
> On Wed, Aug 24, 2011 at 02:38:12PM -0700, Linus Torvalds wrote:
>> On Wed, Aug 24, 2011 at 1:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Can't we just get rid of the small ticket size code path?
>>>
>>> I couldn't benchmark any difference between the two last time
>>> I tried.
>> The small locks aren't any faster. They are just smaller.
> Are you sure? 
>
> AFAIK it's always
>
> typedef struct arch_spinlock {
>         unsigned int slock;
> } arch_spinlock_t;

Hm, I changed that in this series; arch_spinlock can be 16 bits in the
<256 case.  I wonder if it matters...

    J
