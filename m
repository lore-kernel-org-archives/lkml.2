Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2EREFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:05:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35761 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2EREFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOoH4GbJ5LQxYnySoh-mpLuaA3kPuHj0r=OhJN+xCs4dBQ@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com>
 <4FB5C050.9070805@kernel.org> <CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
 <CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
 <4FB5C843.9070002@kernel.org> <CAMe9rOoH4GbJ5LQxYnySoh-mpLuaA3kPuHj0r=OhJN+xCs4dBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 21:05:24 -0700
X-Google-Sender-Auth: 3RCEalDsbdXx3Me5DXo8JQBlk4Q
Message-ID: <CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 8:59 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>
> But __BITS_PER_LONG used in kernel header files really
> means "long" as seen by kernel, not by user space.

No, hjl, no it does NOT.

That might be what we'd all *wish* it did, but it's not at all what it does.

What it actually means is "how many bits in a long as it is being
compiled right now".

User code headers have absolutely *no* idea what the size "long" the
kernel was compiled with. You'd have to do an "uname()" system call to
figure that out, and even then you shouldn't be sure if the kernel is
just really good at compatibility mode.

Just look at the code. It literally sets __BITS_PER_LONG depending on
*compiler* flags like __s390x__ etc. Which depend on things like
"-m32" etc as done in user space.

When those same headers are compiled *as*part*of*the*kernel*, then -
and only then - does __BITS_PER_LONG hopefully match what the kernel
"long" is. But that is kind of irrelevant, because if this was purely
a kernel issue, we would use the non-underscore version (ie just
"BITS_PER_LONG") which is *only* for the kernel, and not exported to
user space at all.

                      Linus
