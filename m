Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab0KQENl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:13:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37203 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab0KQENj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
References: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Nov 2010 21:13:17 -0700
X-Google-Sender-Auth: XobUkEfj4Ol3SH2081s472-ZBzE
Message-ID: <AANLkTimQtXeCE1Gu4YuPBBZ_J3ieW6Z5JtvzF=hF7pWX@mail.gmail.com>
Subject: Re: Behavior of BUG() [Was: Re: [PATCH 2/5] of/fdt: add kernel
 command line option for dtb_compat string]
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> [CC: list reduced as starting a new thread, most on the context
> removed as this concern a different issue.]
>
> On Tue, Nov 16, 2010 at 7:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
>>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>> [...]
>> The kernel needs to complain *loudly* if this occurs because it
>> represents a bug.  I'm tempted to say use BUG, but that would halt the
>> kernel and prevent any possibility of kernel log output.
>> [...]
> does it ? if CONFIG_BUG is not enabled and the arch has no define for
> it, the default does _nothing_:
>
> from `include/asm-generic/bug.h':
>
> #else /* !CONFIG_BUG */
> #ifndef HAVE_ARCH_BUG
> #define BUG() do {} while(0)
> #endif
>
> #ifndef HAVE_ARCH_BUG_ON
> #define BUG_ON(condition) do { if (condition) ; } while(0)
> #endif
> [...]
>
> gcc is triggering about ~30 warnings (like [0]) on code path using
> BUG(). Most of these path assume BUG() will never return, which is not
> true.

As far as I know, BUG() is not supposed to return.  Period.  The patch
below is part of the linux-tiny work, and should only ever be used on
embedded systems where small size is more important than debugability.

g.

>
> The commit message introducing this behavior state:
>
> commit c8538a7aa5527d02c7191ac5da124efadf6a2827
> Author: Matt Mackall <mpm@selenic.com>
> Date:   Sun May 1 08:59:01 2005 -0700
>
>    [PATCH] remove all kernel BUGs
>
>    This patch eliminates all kernel BUGs, trims about 35k off the typical
>    kernel, and makes the system slightly faster.
>
>    Signed-off-by: Matt Mackall <mpm@selenic.com>
>    Signed-off-by: Andrew Morton <akpm@osdl.org>
>    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>
> [...]
>
> +config BUG
> +       bool "BUG() support" if EMBEDDED
> +       default y
> +       help
> +          Disabling this option eliminates support for BUG and WARN, reducing
> +          the size of your kernel image and potentially quietly ignoring
> +          numerous fatal conditions. You should only consider disabling this
> +          option for embedded systems with no facilities for reporting errors.
>
> So how should BUG() been used ?
>  1) assuming it will never _ever_ return ?
>  2) assuming it may return ?
>
> if (1), its definition has to be changed, if (2) a lot of path have to be fixed.

The answer is 1).

g.
