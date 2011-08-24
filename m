Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HXXKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:10:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab1HXXK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <4E5583B3.8080309@zytor.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
 <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com>
 <4E555AD0.3020101@goop.org> <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com>
 <4E558236.9000707@goop.org> <4E5583B3.8080309@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 16:09:31 -0700
Message-ID: <CA+55aFw5T_rkH7195E=P_YO9sjvJbsG4j6n40=fXbdrJktAYjQ@mail.gmail.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 4:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> That's not guaranteed in any way to generate a locally atomic instruction.

No such guarantee is needed - we hold the lock (until the last store),
so as long as it doesn't do anything completely crazy, then the
"head++" will work.

However, the reason I disagree with it is that I don't think that it's
any prettier at all to have the two barriers than it is to just have
the asm.

I see no advantage of a three-line "pseudo-C" code with two magic
barriers over just doing it with the inline asm. The fact that the
inline asm also makes the OOSTORE case trivial is just gravy.

                     Linus
