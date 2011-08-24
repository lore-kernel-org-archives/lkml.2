Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1HXW7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:59:06 -0400
Received: from claw.goop.org ([74.207.240.146]:53905 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1HXW7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:59:04 -0400
Message-ID: <4E558236.9000707@goop.org>
Date: Wed, 24 Aug 2011 15:59:02 -0700
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
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com> <4E555AD0.3020101@goop.org> <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com>
In-Reply-To: <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:53 PM, Linus Torvalds wrote:
> On Wed, Aug 24, 2011 at 1:10 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Could we just kill SMP support for OOSTORE machines now?  That would be
>> the cleanest possible fix...
> No it wouldn't. The asm version would *still* be cleaner than the "C
> plus random barriers".
>
> It's not like the C version is "portable" in any case.

If there's no need to have a locked instruction, then it could simply be:

    barrier();
    lock->head++;
    barrier();

with no need for asm at all.

    J
