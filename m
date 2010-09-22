Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0IVKsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:48:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52054 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0IVKsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LPlp9WQck1F8jv5GDsb4yLbtz+v4Hq+OUvwubK+L/bVcumhZhccngPDCsGz+wLK4Dn
         QNBsLHnHwvM379XtXBmvtlv4W9SPZgQI4bxgNcZ8j8f3h/sjzfWUtsZcSZMmMfCA3gv6
         IF2Co2kNMDVi9CSF99eIVFGsJcAp2ZRC4C5PA=
MIME-Version: 1.0
In-Reply-To: <20100922090336.GA5338@basil.fritz.box>
References: <20100922090336.GA5338@basil.fritz.box>
Date: Wed, 22 Sep 2010 12:48:05 +0200
X-Google-Sender-Auth: Cxlkx1RQbvOLaWVW4r6SFv7vtqo
Message-ID: <AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
From: John Kacur <jkacur@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Fix the perf Makefile to compile on opensuse 10.0
>
> -Werror in shipping code is usually a bad idea. Remove that.

Why not remove it then when you ship the code, but leave it in the kernel
where it is useful?

> Also remove warning options that are not supported in older compilers.

I can get on-board with the above though.

> And fix a missing include for __always_inline.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 4f1fa77..1bf4d9c 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -201,13 +201,13 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
> -EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
> +#EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
> -EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
> +#EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
> @@ -224,7 +224,7 @@ ifndef PERF_DEBUG
>   CFLAGS_OPTIMIZE = -O6
>  endif
>
> -CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
> +CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
>  EXTLIBS = -lpthread -lrt -lelf -lm
>  ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>  ALL_LDFLAGS = $(LDFLAGS)
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index bb4ac2e..305f1c2 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -2,6 +2,7 @@
>  #define _PERF_LINUX_BITOPS_H_
>
>  #include <linux/kernel.h>
> +#include <linux/compiler.h>
>  #include <asm/hweight.h>
>
>  #define BITS_PER_LONG __WORDSIZE
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
