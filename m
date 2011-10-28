Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1J1NGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:06:01 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42451 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab1J1NGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <1319796904-799-1-git-send-email-linus.walleij@linaro.org>
References: <1319796904-799-1-git-send-email-linus.walleij@linaro.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Oct 2011 06:05:36 -0700
X-Google-Sender-Auth: 0srLF1bVR6z18Y_aLYpoPysEfXw
Message-ID: <CA+55aFx8ci-yzPDZDZTqLG4wDx5_t1Od_DRQWJ78PrWU4i5K4Q@mail.gmail.com>
Subject: Re: [PATCH] RFC: fs to be compiled with -Dlinux
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 3:15 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> I dunno how to solve this problem the real way or if I'm just doing
> something idiotic. I'm using a vanilla GCC "arm-none-eabi-gcc" not
> targeted at any specific OS so the environment variable "linux" is
> not set.

You need to fix that in general.

It's not just "-Dlinux", it's "-D__linux__" too, and it's not just in fs/.

So you need to add it to some CFLAGS at your own build infrastructure,
not in fs/Makefile.

That said, we *probably* should also look at making anything that the
kernel build uses replace something like

  #ifdef linux  (or __linux__)

with

  #if defined(linux) || defined(__KERNEL__)

so that we can always rely on just the normal __KERNEL__ define rather
than depending on the compiler being properly set up for
cross-compiling for Linux.

But your patch is definitely wrong.

                      Linus
