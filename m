Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1HZAiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:38:12 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44050 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753549Ab1HZAiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:38:11 -0400
Subject: Re: [PATCH] mm: Neaten warn_alloc_failed
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110825170534.0d425c75.akpm@linux-foundation.org>
References: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
	 <20110825165006.af771ef7.akpm@linux-foundation.org>
	 <1314316801.19476.6.camel@Joe-Laptop>
	 <20110825170534.0d425c75.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 17:38:08 -0700
Message-ID: <1314319088.19476.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 17:05 -0700, Andrew Morton wrote:
> On Thu, 25 Aug 2011 17:00:01 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Thu, 2011-08-25 at 16:50 -0700, Andrew Morton wrote:
> > > On Thu, 25 Aug 2011 13:26:19 -0700
> > > Joe Perches <joe@perches.com> wrote:
> > > > Add __attribute__((format (printf...) to the function
> > > > to validate format and arguments.  Use vsprintf extension
> > > > %pV to avoid any possible message interleaving. Coalesce
> > > > format string.  Convert printks/pr_warning to pr_warn.
> > []
> > > > -extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
> > > > +extern __attribute__((format (printf, 3, 4)))
> > > > +void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > looky:
> > Looky what?
> > There are _far_ more uses of __attribute__((format...)
> > than __printf(...)
> > I generally go with what's more commonly used,
> > especially when it's 206 to 8, and 1 of the
> > 8 is the #define itself.
> > $ grep -rP --include=*.[ch] "__attribute__.*format" * | wc -l
> > 206
> > $ grep -rP --include=*.[ch]  -w "__printf" * | wc -l
> > 8
> So?

So if you really like it that much:

grep -rPl --include=*.[ch] -w "__attribute__" * |
grep -v "^tools" | grep -v "^scripts" | grep -v "include/linux/compiler-gcc.h" |
xargs perl -n -i -e 'local $/; while (<>) { s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.+)\s*,\s*(.+)\s*\)\s*\)\s*\)/__printf($1, $2)/g ; print; }'

Then they're all the same.

cheers, Joe

