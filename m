Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AQEjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 23:39:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1AQEjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 23:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FwjSAgJHBMyfned5cll6sXOXXLCDW32xnTlx/iu6a6rndmXiIqYXACsU0O+NBafPRl
         Uv/4LukkSGETjKXpKrBjZKxWNzvMio2U/Gh49wDVU021WVfQwU+rA/A62qIcyRWGDGa8
         Qt13SPYfBCRSLWkCltLBs97Dudf68hKYK9pbE=
MIME-Version: 1.0
In-Reply-To: <1285224612-29529-1-git-send-email-mfm@muteddisk.com>
References: <1285224612-29529-1-git-send-email-mfm@muteddisk.com>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 17 Jan 2011 04:38:54 +0000
Message-ID: <AANLkTim5VZ+8K3o-i6sQy=EHfgns-ZvLG_roaAsL-_j_@mail.gmail.com>
Subject: Re: [PATCH 03/20] alpha: change to new flag variables
To: matt mooney <mfm@muteddisk.com>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 6:50 AM, matt mooney <mfm@muteddisk.com> wrote:
> Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.
>
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  arch/alpha/kernel/Makefile   |    4 ++--
>  arch/alpha/lib/Makefile      |    4 ++--
>  arch/alpha/math-emu/Makefile |    2 +-
>  arch/alpha/mm/Makefile       |    2 +-
>  arch/alpha/oprofile/Makefile |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
> index 1ee9b5b..9bb7b85 100644
> --- a/arch/alpha/kernel/Makefile
> +++ b/arch/alpha/kernel/Makefile
> @@ -3,8 +3,8 @@
>  #
>
>  extra-y                := head.o vmlinux.lds
> -EXTRA_AFLAGS   := $(KBUILD_CFLAGS)
> -EXTRA_CFLAGS   := -Werror -Wno-sign-compare
> +asflags-y      := $(KBUILD_CFLAGS)
> +ccflags-y      := -Werror -Wno-sign-compare
>
>  obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
>            irq_alpha.o signal.o setup.o ptrace.o time.o \
> diff --git a/arch/alpha/lib/Makefile b/arch/alpha/lib/Makefile
> index 9b72c59..c0a83ab 100644
> --- a/arch/alpha/lib/Makefile
> +++ b/arch/alpha/lib/Makefile
> @@ -2,8 +2,8 @@
>  # Makefile for alpha-specific library files..
>  #
>
> -EXTRA_AFLAGS := $(KBUILD_CFLAGS)
> -EXTRA_CFLAGS := -Werror
> +asflags-y := $(KBUILD_CFLAGS)
> +ccflags-y := -Werror
>
>  # Many of these routines have implementations tuned for ev6.
>  # Choose them iff we're targeting ev6 specifically.
> diff --git a/arch/alpha/math-emu/Makefile b/arch/alpha/math-emu/Makefile
> index 359ef08..7f46719 100644
> --- a/arch/alpha/math-emu/Makefile
> +++ b/arch/alpha/math-emu/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the FPU instruction emulation.
>  #
>
> -EXTRA_CFLAGS := -w
> +ccflags-y := -w
>
>  obj-$(CONFIG_MATHEMU) += math-emu.o
>
> diff --git a/arch/alpha/mm/Makefile b/arch/alpha/mm/Makefile
> index 09399c5..c993d3f 100644
> --- a/arch/alpha/mm/Makefile
> +++ b/arch/alpha/mm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the linux alpha-specific parts of the memory manager.
>  #
>
> -EXTRA_CFLAGS := -Werror
> +ccflags-y := -Werror
>
>  obj-y  := init.o fault.o extable.o
>
> diff --git a/arch/alpha/oprofile/Makefile b/arch/alpha/oprofile/Makefile
> index 4aa5624..3473de7 100644
> --- a/arch/alpha/oprofile/Makefile
> +++ b/arch/alpha/oprofile/Makefile
> @@ -1,4 +1,4 @@
> -EXTRA_CFLAGS := -Werror -Wno-sign-compare
> +ccflags-y := -Werror -Wno-sign-compare
>
>  obj-$(CONFIG_OPROFILE) += oprofile.o
>
> --
> 1.7.2.1

Thanks for the patch. This has been applied and will be sent to Linus for .38.

Matt
