Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0CXK6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:58:10 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:46056 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab0CXK6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E0Kpd4dMPpMGpXFTw8KrYapvvRHAoq7nGA/4gi6s1u5Clw5IkYBOM6h73H47krkIBG
         lnKmVfu+OfiIf740MlniDoEy61pJP48AH2yzXVnwqTgv0PdxIM0Dhnkoz7lE6wTjPXHC
         CtNXYmV9oD+Um5ijs6sR7TgM9UxtG2/2OernE=
MIME-Version: 1.0
In-Reply-To: <1269420538-18039-2-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
	 <1269420538-18039-2-git-send-email-tj@kernel.org>
Date: Wed, 24 Mar 2010 12:58:05 +0200
X-Google-Sender-Auth: 8666c0eef26a7454
Message-ID: <84144f021003240358i2c9e51a5lf9877ec5b0597992@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86: don't include slab.h from arch/x86/include/asm/pgtable_32.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:48 AM, Tejun Heo <tj@kernel.org> wrote:
> Including slab.h from x86 pgtable_32.h creates a troublesome
> dependency chain w/ ftrace enabled.  The following chain leads to
> inclusion of pgtable_32.h from define_trace.h.
>
>  trace/define_trace.h
>  trace/ftrace.h
>  linux/ftrace_event.h
>  linux/ring_buffer.h
>  linux/mm.h
>  asm/pgtable.h
>  asm/pgtable_32.h
>
> And when slab.h itself defines trace hooks via
>
>  linux/sl[aou]b_def.h
>  linux/kmemtrace.h
>  trace/events/kmem.h
>
> If slab.h is not included before define_trace.h is included, this
> leads to duplicate definitions of kmemtrace hooks or other include
> dependency problems.
>
> pgtable_32.h doesn't need slab.h to begin with.  Don't include it from
> there.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  arch/x86/include/asm/pgtable_32.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
> index 47339a1..2984a25 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -19,7 +19,6 @@
>  #include <asm/paravirt.h>
>
>  #include <linux/bitops.h>
> -#include <linux/slab.h>
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
