Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2DNApA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:45:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40193 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab2DNAo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <201204140118.51534.l.lunak@suse.cz>
References: <201204132124.21294.l.lunak@suse.cz> <20120413170151.20c7230e@wrlaptop>
 <CA+55aFz0c43QARhefvhdiB=H6buO7VpEOnNbuJTYEcUn8M+mKw@mail.gmail.com> <201204140118.51534.l.lunak@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 17:44:37 -0700
X-Google-Sender-Auth: NxvUViY7T5WlQkVKskgRCm2LwUI
Message-ID: <CA+55aFzWiaXYSwO7eGt_V6oUZGWkp_v1hv9xc6KAiFnrzumxXA@mail.gmail.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
To: Lubos Lunak <l.lunak@suse.cz>
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 4:18 PM, Lubos Lunak <l.lunak@suse.cz> wrote:
>> imagine replacing the kernel ((void *)0) with __null.
>
>  __null apparently exists only with g++, C does not have the stronger type
> safety that prevents ((void*)0) from being usable in C++

Please don't continue to spread this total bogosity.

The reason C++ cannot use "(void *)0" has nothing to do with "stronger
type safety". That's a total idiotic lie by C++ apologists, and I hate
hearing it repeated over and over again.

And it really *is* a lie. The C++ type system isn't even "stronger",
it's just different, and it's actively *broken* wrt NULL. Always has
been.

The sane thing to do for C++ would always have been to recognize that
"(void *)0" is not a "void pointer" - it's just NULL. INSTEAD, the
morons involved said "no, it's a void pointer, and instead we'll make
'0' be NULL".

Which is clearly insane, but is also technically simply *wrong*.

0 is an integer, it's not NULL _either_, and it's just a more stupid
version of NULL.

So the C++ people then completely made up the argument that "C++ has a
stronger type system, we can't use 'void *', so the C style ((void
*)0) is wrong for C++".

Which is utter and complete bullshit, and any amount of brains would
have realized that (since C++ at the same time happily continued to
special case the *integer* zero).

I don't hate __null, but I absolutely despise the crazy C++ apologists
who try to claim that C++ was somehow "right" in not accepting (void
*)0, and that it was somehow about "type safety". No, it was not. It
has always been just nothing but a moronic hang-up, and it has always
been *wrong*.

So don't spread that lie. It was wrong. The fact is, the *constant* 0
is the special one, and C++ could have (and should have) just accepted
that that constant should have been cast to (void *) and that is what
NULL is defined to. Instead, C++ used the *weaker* type system of
saying that the *integer* constant 0 is NULL, which is pure and utter
garbage.

And then they lie, and claim that their *weaker* type system NULL is
"stronger". Pure idiocy.

                 Linus
