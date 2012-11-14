Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797Ab2KNMs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:48:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43273 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422711Ab2KNMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:48:24 -0500
MIME-Version: 1.0
In-Reply-To: <201211141218.02105.arnd@arndb.de>
References: <201211141218.02105.arnd@arndb.de>
Date: Wed, 14 Nov 2012 13:48:22 +0100
X-Google-Sender-Auth: l63bSXYTGHUiSPrzljujRuc4tAw
Message-ID: <CAMuHMdW3uBWgJfftFxnf8qySBmqSRDRhoivBdk6Zsc+cC2Sitg@mail.gmail.com>
Subject: Re: new architectures, time_t __kernel_long_t
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 1:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The other types that are used as 64 bit on x32 are ino_t, nlink_t,
> size_t, ssize_t, ptrdiff_t, and off_t.
>
> Obviously, we want to use 64-bit off_t, but this is achieved already
> through loff_t, which is used in all places in the asm-generic
> ABI anyway (the syscalls using off_t are stripped out). I don't

Indeed.

> think we want to have the other ones set to 64 bit on ARC or Meta,
> although I'm not 100% sure about ino_t and nlink_t.

Is ino_t related to inode numbers stored in on-disk file system metadata?

Currently, nlink_t is unconditionally __u32, even on 64-bit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
