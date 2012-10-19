Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab2JST6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:58:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37727 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab2JST6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <87fw5bp858.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
 <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
 <87fw5bp858.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 12:58:16 -0700
X-Google-Sender-Auth: 6E3OraatNkJQtVW2prRD9TgMFrc
Message-ID: <CA+55aFx339WquJEjijeRQ+12Aw0sa+MoL+kFttjbJLJ6S1Jy+Q@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 6:23 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Smerged them together: no point moving the x509keyid script now.
> I dropped the optional dst arg, since we don't use it.
>
> Thanks,
> Rusty.
> ===
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: [PATCH] kbuild: sign the modules at install time
>
> Linus deleted the old code and put signing on the install command,
> I fixed it to extract the keyid and signer-name within sign-file
> and cleaned up that script now it always signs in-place.

Ugh. That was horribly broken, and sadly I didn't notice until several
pulls later (I tend to try to compile-test much more often, but do
boot-tests only a couple of times a day).

You clearly hadn't tested that patch at all, the resulting signature
was broken in two independent and totally different ways.

Tssk. I fixed it up, and now it works-for-me(tm), but some perl person
probably really should try to make that sign-file and x509keyid merge.
My fix made the thing even slower, doing two extra "wc -c" invocations
since it can't do "${#..}" expansion due to the locale problem.

             Linus
