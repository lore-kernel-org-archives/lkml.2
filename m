Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1GRKg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:36:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:39558 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1GRKg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="28389135"
Subject: Re: [PATCH 1/2] lib: make TOLOWER macro public
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CACVxJT8P_0VcL6f40GixgrvYjh1TBaVwdGwHH3VatG+87mMHHg@mail.gmail.com>
References: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
	 <CACVxJT8P_0VcL6f40GixgrvYjh1TBaVwdGwHH3VatG+87mMHHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: Intel Finland Oy
Date: Mon, 18 Jul 2011 13:36:29 +0300
Message-ID: <1310985389.3903.0.camel@smile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 13:25 +0300, Alexey Dobriyan wrote: 
> NAK
> This macro sucks because name doesn't reflect hackish nature.
> _tolower() should be moved into public header.
> 
Makes sense. I think whole _tolower() could be moved to kernel.h.

> On Mon, Jul 18, 2011 at 11:23 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > This macro is required by *printf and kstrto* functions that are located
> > in the different modules. This patch makes TOLOWER macro public.
> > However, it's good idea to not use the macro outside of mentioned
> > functions.
> 
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> 
> > +/* Works only for digits and letters, but small and fast */
> > +#define TOLOWER(x) ((x) | 0x20)
> 
> > --- a/lib/kstrtox.c
> > +++ b/lib/kstrtox.c
> > @@ -19,11 +19,6 @@
> >  #include <linux/types.h>
> >  #include <asm/uaccess.h>
> >
> > -static inline char _tolower(const char c)
> > -{
> > -       return c | 0x20;
> > -}

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
