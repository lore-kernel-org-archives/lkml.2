Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1HXVn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:43:27 -0400
Received: from claw.goop.org ([74.207.240.146]:53602 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1HXVnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:43:24 -0400
Message-ID: <4E55707A.2080102@goop.org>
Date: Wed, 24 Aug 2011 14:43:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com> <m2pqjud1fz.fsf@firstfloor.org> <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com>
In-Reply-To: <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 02:38 PM, Linus Torvalds wrote:
> Many data structures have spinlocks inside of them, and the smaller
> spinlock *should* be able to result in smaller data structures.
>
> Of course, that assumes that they have been packed correctly. And they
> seldom are ;(
>
> Looking at 'struct task_struct', for example, the spinlocks there
> aren't next to each other, and have pointers and 'unsigned int's
> around them, so rather than shrinking the data structure, it just
> results in holes.

Wouldn't sticking all the spinlocks together just result in false
sharing?  Wouldn't it be best to put them right next to the fields they
protect so the act of getting the lock also gets you your data?

    J
