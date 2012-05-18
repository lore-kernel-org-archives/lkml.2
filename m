Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2EREOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:14:01 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36433 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2EREN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
	<4FB58EFD.7010302@zytor.com>
	<4FB5C050.9070805@kernel.org>
	<CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
	<CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
	<4FB5C843.9070002@kernel.org>
	<CAMe9rOoH4GbJ5LQxYnySoh-mpLuaA3kPuHj0r=OhJN+xCs4dBQ@mail.gmail.com>
	<CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com>
Date: Thu, 17 May 2012 21:13:58 -0700
Message-ID: <CAMe9rOr883q0OAsh+JGA83ww603y6QSbQJKx+wk2YJfkYcaEdQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 9:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 17, 2012 at 8:59 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>
>> But __BITS_PER_LONG used in kernel header files really
>> means "long" as seen by kernel, not by user space.
>
> No, hjl, no it does NOT.
>
> That might be what we'd all *wish* it did, but it's not at all what it does.
>
> What it actually means is "how many bits in a long as it is being
> compiled right now".
>
> User code headers have absolutely *no* idea what the size "long" the
> kernel was compiled with. You'd have to do an "uname()" system call to
> figure that out, and even then you shouldn't be sure if the kernel is
> just really good at compatibility mode.
>
> Just look at the code. It literally sets __BITS_PER_LONG depending on
> *compiler* flags like __s390x__ etc. Which depend on things like
> "-m32" etc as done in user space.
>
> When those same headers are compiled *as*part*of*the*kernel*, then -
> and only then - does __BITS_PER_LONG hopefully match what the kernel
> "long" is. But that is kind of irrelevant, because if this was purely
> a kernel issue, we would use the non-underscore version (ie just
> "BITS_PER_LONG") which is *only* for the kernel, and not exported to
> user space at all.
>

Since x32 uses the same kernel interface as x86-64 with a few
exceptions.  The current kernel header files with

#ifdef __x86_64__
# define __BITS_PER_LONG 64
#else
# define __BITS_PER_LONG 32
#endif

#if __BITS_PER_LONG == 64
Define x86-64 types
#endif

work fine for x32 even if long for x32 is 32 bits.  If __BITS_PER_LONG
is changed to 32 for x32, many types in kernel header files will be
wrong for x32.


-- 
H.J.
