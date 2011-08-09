Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1HIPlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:41:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230Ab1HIPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <1312880303.1676.5.camel@Joe-Laptop>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
 <1312847115.1643.22.camel@Joe-Laptop> <20110809055226.GE6103@google.com> <1312880303.1676.5.camel@Joe-Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Aug 2011 08:41:00 -0700
Message-ID: <CA+55aFwHEoDkWr6Mh=r1KG4MLRbY0_iVF-v3BPkK+zhxkriHdw@mail.gmail.com>
Subject: Re: [PATCH] treewide: Update sha_transform
To: Joe Perches <joe@perches.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        GeertUytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 1:58 AM, Joe Perches <joe@perches.com> wrote:
>
> Eliminate possible sha_transform unaligned accesses to data by copying
> data to an aligned __u32 array if necessary.

This is wrong. Not only does it double the stack space, when I tried
it for git it just made things slower. So don't do it.

If some architecture has a bad "get_unaligned_be32()", then that's
just something for the arch maintainers to fix.

> Add sha_transform wipe argument to force workspace clearing if desired.

I disagree. As already mentioned, any competent compiler would make
that thing go away anyway. And there is no reason to believe that it's
actually a real fix for any real security issue, so it's voodoo
programming for several reasons.

We shouldn't do voodoo stuff. Or rather, I'm perfectly ok if you guys
all do your little wax figures of me in the privacy of your own homes
- freedom of religion and all that - but please don't do it in the
kernel.

                    Linus
