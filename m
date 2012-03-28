Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2C1IDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:03:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34236 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740Ab2C1IDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:03:41 -0400
Message-ID: <1332921820.16535.32.camel@joe2Laptop>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 01:03:40 -0700
In-Reply-To: <CAMuHMdWOw+UgdL7H9MLm6LLEFBkuqecrc4urHMYi7E7eTGWz4w@mail.gmail.com>
References: <1332869030.2213.46.camel@joe2Laptop>
	 <CAMuHMdWOw+UgdL7H9MLm6LLEFBkuqecrc4urHMYi7E7eTGWz4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 09:42 +0200, Geert Uytterhoeven wrote:
> On Tue, Mar 27, 2012 at 19:23, Joe Perches <joe@perches.com> wrote:
> >  #ifndef pr_fmt
> > +
> > +#ifndef pr_fmt_std
> > +#define pr_fmt_std(fmt) KBUILD_MODNAME ": " fmt
> > +#endif
> > +#ifndef pr_fmt_dbg
> > +#define pr_fmt_dbg(fmt) fmt
> > +#endif
> >  #define pr_fmt(fmt) fmt
> 
> What's the rationale behind the above line?
> I had expected
> 
>      #define pr_fmt(fmt) pr_fmt_std(fmt)

Keeping current pr_debug output as similar to
possible to the output produced by this patch.

pr_debug predates pr_fmt by quite awhile, it
dates back from kernel version 2.0 days, and
there are _many_ instances of pr_debug in files
without a pr_fmt define.

The other defines of pr_<level> were introduced
more or less the same time as pr_fmt so there
aren't _too_ many that couldn't reasonably be
prefixed.

commit d091c2f58ba32029495a933b721e8e02fbd12caa
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Wed Nov 12 21:16:43 2008 +0100

    Add 'pr_fmt()' format modifier to pr_xyz macros.

commit 1f7c8234c7a68c2ccc2a33f3b7d48057980e7c35
Author: Emil Medve <Emilian.Medve@Freescale.com>
Date:   Tue Oct 16 23:29:48 2007 -0700

    Make the pr_*() family of macros in kernel.h complete

> > +#ifndef pr_fmt_std
> > +#define pr_fmt_std(fmt...) pr_fmt(fmt)
> 
> Why the "fmt..." here, and "fmt" in the definitions above?

Where pr_fmt is already defined, these pr_fmt_std and _dbg
macros must work with pr_fmt defines like:

#define pr_fmt(fmt) "my special prefix:%s:%d", __func__, __LINE__



