Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2DMTjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:39:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38670 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DMTjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <201204132124.21294.l.lunak@suse.cz>
References: <201204132124.21294.l.lunak@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 12:39:20 -0700
X-Google-Sender-Auth: aFnHTgu3fHplXqk7YvnGlEBM7Pk
Message-ID: <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
To: Lubos Lunak <l.lunak@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 12:24 PM, Lubos Lunak <l.lunak@suse.cz> wrote:
> GCC's NULL is actually __null, which allows detecting some questionable
> NULL usage and warn about it. Moreover each platform/compiler should have
> its own stddef.h anyway (which is different from linux/stddef.h).
> So there's no good reason to override what the compiler provides.
> Keep the #define conditionally, in order to keep the headers self-contained.

There's no way user should ever include the linux internal stddef.h.

And quite frankly, kernel-external definitions of NULL have
traditionally been pure sh*t (ie plain "0" without the cast to a
pointer), so I'm not entirely convinced about this patch.

So what is the *actual* thing this helps with?

                    Linus
