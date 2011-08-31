Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1HaQ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:26:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56585 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab1HaQ0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:26:35 -0400
Message-ID: <4E5E6075.6060209@zytor.com>
Date: Wed, 31 Aug 2011 09:25:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de>
In-Reply-To: <201108311814.54906.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 09:14 AM, Arnd Bergmann wrote:
> 
> Ok, but I think we do need to consider the potential problems in this.
> I would expect a number of things to break if we just define it to
> 'long long' on new architectures, including:
> 
> * pre-c99 C compilers or programs that rely on --std=c89

This is a very long time ago by now.  Pre-C99 compilers without the long
long extension probably don't exist for these new architectures;
applications is a little bit messier, but still.

> * padding in struct timespec when you have a long long tv_sec and
>   32-bit long tv_nsec. This might cause kernel stack data leakage
>   in some kernel interfaces when they don't clear the padding.

Don't to that then.  For what it's worth, I think we currently use the
same size for both fields.

> * random broken applications assuming that timespec/timeval has
>   two 'long' members, instead of using the proper header files.
> 
> Obviously these are all fixable for any new ABI, but will cause
> some annoyance.
> 
> I've added a few people to Cc who are in various stages of the
> process to finalize their upstream kernel ports. It's clearly
> the right decision to have time_t 64-bit eventually, the question
> is how much work is everyone willing to spend in the short run,
> and who is going to test it. In particular, openrisc has just
> been merged, so we should not be changing it any more unless
> there is a serious problem, but if there is not much legacy user
> space with the current ABI yet, it may still be worth switching
> over.

Either way, all of this applies to x32 even more, sadly.

The other thing is that we probably need to do is to set a date when we
redefine legacy 32-bit time_t to be unsigned.  A good time might be some
time around (time_t)0x60000000 = Thu Jan 14 08:25:36 UTC 2021 if not sooner.

	-hpa
