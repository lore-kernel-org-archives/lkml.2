Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1DFUmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:42:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:37522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab1DFUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:42:46 -0400
Date: Wed, 6 Apr 2011 13:42:44 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] brk: COMPAT_BRK: fix detection of randomized brk (was
 Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
 computation forCOMPAT_BRK)
In-Reply-To: <BANLkTinhTM3pntJauwpxSEd02MDAB+VS1w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1104061341550.5855@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz> <AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
 <alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz> <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com> <alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz> <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com> <alpine.LNX.2.00.1104061155530.5855@pobox.suse.cz>
 <BANLkTinnvXX70OCrtyYy_2e-zJDqS9f2iw@mail.gmail.com> <alpine.LNX.2.00.1104061336190.5855@pobox.suse.cz> <BANLkTinhTM3pntJauwpxSEd02MDAB+VS1w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011, Geert Uytterhoeven wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: brk: COMPAT_BRK: fix detection of randomized brk
> >
> > 5520e89 ("brk: fix min_brk lower bound computation for COMPAT_BRK")
> > tried to get the whole logic of brk randomization for legacy (libc5-based)
> > applications finally right.
> >
> > It turns out that the way to detect whether brk has actually been randomized in
> > the end or not introduced by that patch still doesn't work for those binaries,
> > as reported by Geert.
> >
> > I don't like it, but currently see no better option than a bit flag in
> > task_struct to catch the CONFIG_COMPAT_BRK && randomize_va_space == 2
> > case.
> >
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >
> > I am not really happy about introducing the bit flag, but I currently
> > don't see another option. And it's only for the legacy CONFIG_COMPAT_BRK
> > case anyway.
> >
> > Andrew, Ingo, any opinions/objections?
> >
> > If not -- Andrew, I guess this should go into current -rc still.
> 
> And in 2.6.38-stable.
> 
> Does anyone still have libc5 binaries for i386?

The first time we introduced brk randomization, Pavel Machek reported a 
problem with some libc5-based binary on some ancient x86 system he had.

So I am afraid there still might be sparse occurences out there.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
