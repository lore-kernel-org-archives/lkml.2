Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1HaRj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab1HaRjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:39:25 -0400
Message-ID: <4E5E71A8.8090209@zytor.com>
Date: Wed, 31 Aug 2011 10:38:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de> <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com> <4E5E6AC0.60000@zytor.com> <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
In-Reply-To: <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 10:19 AM, Linus Torvalds wrote:
> 
> I think tv_nsec was just overlooked, and people thought "it has no
> legacy users that were 'int', so we'll just leave it at 'long', which
> is guaranteed to be enough for nanoseconds that only needs a range of
> 32 bits".
> 
> In contrast, tv_usec probably *does* have legacy users that are "int".
> 
> So POSIX almost certainly only looked backwards, and never thought
> about users who would need to make it "long long" for compatibility
> reasons.
> 
> The fact that *every*other*related*field* in POSIX/SuS has a typedef
> exactly for these kinds of reasons just shows how stupid that "long
> tv_nsec" thing is.
> 
> I suspect that on Linux we can just say "tv_nsec" is suseconds_t too.
> Then we can make time_t and suseconds_t just match, and be "__s64" on
> all new platforms.
> 

Let me see if I can raise this with the POSIX committee.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

