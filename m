Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1HaRUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:20:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914Ab1HaRUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <4E5E6AC0.60000@zytor.com>
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de>
 <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de>
 <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com> <4E5E6AC0.60000@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Aug 2011 10:19:23 -0700
Message-ID: <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:09 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I suspect only sane solution to this (having thought about it some
>> more) is to just say "POSIX is f*^&ing wrong".
>
> Urk.  Someone had the bright idea of defining tv_nsec as "long" in the
> standard, whereas tv_usec is suseconds_t.  F**** brilliant, and more
> than a little bit stupid.

I think tv_nsec was just overlooked, and people thought "it has no
legacy users that were 'int', so we'll just leave it at 'long', which
is guaranteed to be enough for nanoseconds that only needs a range of
32 bits".

In contrast, tv_usec probably *does* have legacy users that are "int".

So POSIX almost certainly only looked backwards, and never thought
about users who would need to make it "long long" for compatibility
reasons.

The fact that *every*other*related*field* in POSIX/SuS has a typedef
exactly for these kinds of reasons just shows how stupid that "long
tv_nsec" thing is.

I suspect that on Linux we can just say "tv_nsec" is suseconds_t too.
Then we can make time_t and suseconds_t just match, and be "__s64" on
all new platforms.

                           Linus
