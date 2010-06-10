Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0FJFcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:32:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56129 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0FJFcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uIzWOBJ+X5vucXsMQQ6j3wEZffbLA9QUvlLVhdRpEjv3EsHpWIyQUSqbV1eJ1+q33a
         YX5ZQpL4AJaDjZaXhhb7U1mCiuDlQJHhjXZMXt0ZhbHdcn7agZ4x256vp2CeIb41n9MK
         o85wTmQQpxklGlj55fmO4XuEzbLBVbZBO8SrU=
MIME-Version: 1.0
In-Reply-To: <4C1018FD.8090109@linux.intel.com>
References: <201005271944.09541.toralf.foerster@gmx.de>
	<20100530170346.GC1565@liondog.tnic>
	<tip-cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0@git.kernel.org>
	<4C1018FD.8090109@linux.intel.com>
Date: Thu, 10 Jun 2010 07:32:20 +0200
X-Google-Sender-Auth: ZoVhS07z2aswlMW18ZdeLSG3IjM
Message-ID: <AANLkTil3rzSvLnxTerj_FxaCLpdokL5BB5z8QOcL7dbr@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, hweight: Fix UML boot crash
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, bharrosh@panasas.com, bp@alien8.de,
       akpm@linux-foundation.org, toralf.foerster@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 00:43, H. Peter Anvin <hpa@linux.intel.com> wrote:
> Note: I have applied this  because it fixes a regression, but it bugs

You seem to have pushed the wrong one, from this/the old thread (new one has
`resent' in the subject)?

> the living bejeezus out of me that the saner patch:
>
> diff --git a/arch/um/include/asm/arch_hweight.h
> b/arch/um/include/asm/arch_hweight.h
> new file mode 100644
> index 0000000..c656cf4
> --- /dev/null
> +++ b/arch/um/include/asm/arch_hweight.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_UM_HWEIGHT_H
> +#define _ASM_UM_HWEIGHT_H
> +
> +#include <asm-generic/bitops/arch_hweight.h>
> +
> +#endif
>
> ... supposedly didn't work.  As such, I consider this a temporary kluge
> until a proper solution is found.  From a code-cleanliness perspective,
> this patch is awful.

It does work, but it needs `make clean' first.

Probably the kbuild dependency system doesn't handle new include files
appearing earlier in the include path than an existing include file.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
