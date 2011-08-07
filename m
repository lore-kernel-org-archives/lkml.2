Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1HGRgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:36:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34366 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1HGRgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
	<CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
	<CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
Date: Sun, 7 Aug 2011 19:36:03 +0200
Message-ID: <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
From: Joachim Eastwood <manabian@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@cam.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 6:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 7, 2011 at 4:54 AM, Joachim  Eastwood <manabian@gmail.com> wrote:
>>
>> I see some ARM asm in your patch, maybe this is the cause?
>
> No, it's just a barrier to make sure the compiler doesn't do crazy
> things, no actual asm instructions involved.
>
> That code is quite well tested in git, so I'm surprised it has any
> problems on arm. It also has zero loops, a hang sounds odd. Can you
> get some more debug information out of it (for example, where it hangs
> - maybe "initcall_debug=1" on the kernel command line?

initcall_debug=1 didn't do anything to the boot log.

But I add some printk's around the calls to sha_init and sha_transform.
...
NET: Registered protocol family 2
extract_buf: call sha_init
extract_buf: call sha_init done
extract_buf: call sha_transform
extract_buf: call sha_transform done
extract_buf: call sha_transform
extract_buf: call sha_transform done
extract_buf: function exit

These printk's come from drivers/char/random.c
So it doesn't seem like it hangs in any of the sha_* funtions.

But I never see any of the printk's I added to net/ipv4/syncookies.c
or net/ipv4/tcp_output.c.

btw, my compiler is: arm-angstrom-linux-gnueabi-gcc (GCC) 4.3.3

regards
Joachim Eastwood

> The biggest difference with the git sources is the slightly different
> calling conventions (passing the workspace array as an argument is bad
> for code generation, btw - since now gcc doesn't see that the
> workspace accesses are dead) and the fact that the kernel version uses
> kernel macros like "get_unaligned_be32()" rather than it's own
> implementation.
>
>                                      Linus
>
