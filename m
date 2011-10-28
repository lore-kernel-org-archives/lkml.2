Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1J1NuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:50:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1J1NuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx8ci-yzPDZDZTqLG4wDx5_t1Od_DRQWJ78PrWU4i5K4Q@mail.gmail.com>
References: <1319796904-799-1-git-send-email-linus.walleij@linaro.org>
	<CA+55aFx8ci-yzPDZDZTqLG4wDx5_t1Od_DRQWJ78PrWU4i5K4Q@mail.gmail.com>
Date: Fri, 28 Oct 2011 15:50:04 +0200
Message-ID: <CACRpkdZgkpn3WZnsSt0fvdBWtMen62Nrat_yAQr3WcA-o8oDuw@mail.gmail.com>
Subject: Re: [PATCH] RFC: fs to be compiled with -Dlinux
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 3:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> So you need to add it to some CFLAGS at your own build infrastructure,
> not in fs/Makefile.

Sure, fixing. I don't have much of an infrastructure, mainly using a
simple makefile so it's a simple thing to fix up.

> That said, we *probably* should also look at making anything that the
> kernel build uses replace something like
>
>  #ifdef linux  (or __linux__)
>
> with
>
>  #if defined(linux) || defined(__KERNEL__)
>
> so that we can always rely on just the normal __KERNEL__ define rather
> than depending on the compiler being properly set up for
> cross-compiling for Linux.

Something like this?

>From 929a7556d27f752466477e2e834e02fb4bd9922e Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@stericsson.com>
Date: Fri, 28 Oct 2011 15:43:22 +0200
Subject: [PATCH] aout: depend on linux or __KERNEL__

As suggested by Torvalds the kernel build should only depend
on __KERNEL__ being set and not rely on compiler definitions
like "linux" or "__linux__".

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/a.out.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index e86dfca..45ea44a 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -129,7 +129,7 @@ enum machine_type {
 #define SEGMENT_SIZE PAGE_SIZE
 #endif

-#ifdef linux
+#if defined(linux) || defined(__KERNEL__)
 #ifdef __KERNEL__
 #include <asm/page.h>
 #else
-- 
1.7.3.2

Yours,
Linus Walleij
