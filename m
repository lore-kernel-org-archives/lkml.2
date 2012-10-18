Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2JRQ3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:29:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34544 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2JRQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121018121154.GE2934@hansolo.jdub.homelinux.org>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <87a9vko0z7.fsf@rustcorp.com.au> <20121018121154.GE2934@hansolo.jdub.homelinux.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Oct 2012 09:29:16 -0700
X-Google-Sender-Auth: _ZXx364bX7qowSrqIEk04zkYowA
Message-ID: <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Josh Boyer <jwboyer@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 5:11 AM, Josh Boyer <jwboyer@redhat.com> wrote:
>
> It also excludes out-of-tree drivers.  I wouldn't personally shed a tear
> for them, but it eliminates a use-case that people could have if we just
> stuck to the signed module approach.
>
> I'd prefer if we just cleaned up what we already have.

Exactly. I think the advantage of module signing is that it allows for
many different use-cases. People who care deeply about security can do
the "sign modules at kernel compile time with a one-time random key
that gets removed", and simply always reject anything else. And maybe
corporate users want something similar for corporate laptops.

And then vendors can do the "sign stuff with vendor key, and print big
warning and/or taint the kernel if loading unsigned modules" so that
people can at least validate the "standard" modules or something.

So signing is the nice flexible option, and technically the right
thing to do. I just want to make sure that what we make the *easy*
thing to do with that flexible option is the nice sane
GoodSecurity(tm) thing. If somebody wants to do something else with
it, fine, but it's not what the primary objective of the makefile
rules should be about.

I like how the default makefiles do that "create and use random key"
thing by default. THAT is what I want to see.

(Side note: I hope people realize that the random key is generated
with a 100-year lifespan. So if you build a kernel today, you do
potentially have a "year-2112 problem". I'm not horribly worried, but
I *am* a bit worried about 32-bit time_t overflow and I hope 32-bit
openssl doesn't do anything odd)

               Linus
