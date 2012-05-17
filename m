Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030644Ab2EQWvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:51:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64460 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030523Ab2EQWvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FB57EB2.4050208@zytor.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <1337292816-10839-2-git-send-email-hjl.tools@gmail.com> <CA+55aFx98qvVg1JhMV0JjgNGb++xtir5ocseY3xgQNc3qAtWdQ@mail.gmail.com>
 <4FB57EB2.4050208@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 15:50:53 -0700
X-Google-Sender-Auth: -TDx6Bu3oBfWW41fvY5YuuO5uKw
Message-ID: <CA+55aFzztct_HzmGiit=9SwwM4_YPuXbjwMdJpM1JHMXGBNqaA@mail.gmail.com>
Subject: Re: [PATCH 01/10] Use __kernel_long_t in struct timex
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It also puts a clear line between the kernel and user space namespaces,
> which has been an ongoing problem (we *still* haven't cleaned out some
> namespace pollution in the i386 <asm/signal.h> for example.)
>
> That being said, this is a lot like the __u* and __s* types which we use
> instead of <stdint.h> for similar reasons.  I don't know if
> __ulong/__slong or __uword/__sword would be better here?

Yes, I do think this is closer to the "__u32" kind of usage, and in
general I tend to think that's true of most of the __kernel_ prefix
things. There is very little "kernely" things about it.

Yes, we have to have the double underscore (or single+capitalized),
but I think that at least personally, I'd be happier with just
"__long" and "__ulong".

I think __word would be good too, *except* for the fact that
especially in x86 land, I think there's the legacy confusion with
"word" being 16-bit. Ugh.

So I don't know. I just do know that I don't see the point in that
"__kernel_" prefix.

                   Linus
