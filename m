Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1GRKZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:25:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46851 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1GRKZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
References: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
Date: Mon, 18 Jul 2011 13:25:12 +0300
Message-ID: <CACVxJT8P_0VcL6f40GixgrvYjh1TBaVwdGwHH3VatG+87mMHHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: make TOLOWER macro public
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK
This macro sucks because name doesn't reflect hackish nature.
_tolower() should be moved into public header.

On Mon, Jul 18, 2011 at 11:23 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This macro is required by *printf and kstrto* functions that are located
> in the different modules. This patch makes TOLOWER macro public.
> However, it's good idea to not use the macro outside of mentioned
> functions.

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h

> +/* Works only for digits and letters, but small and fast */
> +#define TOLOWER(x) ((x) | 0x20)

> --- a/lib/kstrtox.c
> +++ b/lib/kstrtox.c
> @@ -19,11 +19,6 @@
>  #include <linux/types.h>
>  #include <asm/uaccess.h>
>
> -static inline char _tolower(const char c)
> -{
> -       return c | 0x20;
> -}
