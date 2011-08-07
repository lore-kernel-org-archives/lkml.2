Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1HGQxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 12:53:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab1HGQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 12:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org> <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 09:52:38 -0700
Message-ID: <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
To: Joachim Eastwood <manabian@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@cam.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 4:54 AM, Joachim  Eastwood <manabian@gmail.com> wrote:
>
> I see some ARM asm in your patch, maybe this is the cause?

No, it's just a barrier to make sure the compiler doesn't do crazy
things, no actual asm instructions involved.

That code is quite well tested in git, so I'm surprised it has any
problems on arm. It also has zero loops, a hang sounds odd. Can you
get some more debug information out of it (for example, where it hangs
- maybe "initcall_debug=1" on the kernel command line?

The biggest difference with the git sources is the slightly different
calling conventions (passing the workspace array as an argument is bad
for code generation, btw - since now gcc doesn't see that the
workspace accesses are dead) and the fact that the kernel version uses
kernel macros like "get_unaligned_be32()" rather than it's own
implementation.

                                      Linus
