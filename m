Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2J3HYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:24:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39925 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2J3HYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:24:21 -0400
Date: Tue, 30 Oct 2012 08:24:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Minyard <cminyard@mvista.com>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH v2] Remove uninitialized_var()
Message-ID: <20121030072416.GA4537@gmail.com>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
 <1350420820-7156-5-git-send-email-minyard@acm.org>
 <20121022164902.9b204646.akpm@linux-foundation.org>
 <508AE611.3020504@mvista.com>
 <CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com>
 <20121027131203.GA27313@gmail.com>
 <20121027114836.e9a6a922.akpm@linux-foundation.org>
 <20121028102007.GA7547@gmail.com>
 <alpine.DEB.2.00.1210291150470.10845@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210291150470.10845@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Sun, 28 Oct 2012, Ingo Molnar wrote:
> 
> > I left it a bit mystic because in some cases this macro was 
> > mis-used not to suppress GCC being wrong, but to hide GCC being 
> > *right*: for example unused variable warnings in cases like:
> > 
> >    int uninitialized_var(var);
> > 
> >    #ifdef XYZ
> >    var = ...;
> >    ...
> >    #endif
> > 
> > which (ab-)use was no doubt actively dangerous beyond being 
> > ugly. One such example is in arch/x86/mm/numa.c. (These cases 
> > now turn into clear (and always harmless) compiler warnings, as 
> > they should.)
> > 
> 
> I like initializing them to 0 or NULL because it will still 
> emit the "unused variable" warnings whereas using 
> uninitialized_var() would not with -Wall.  It's quite possible 
> that uninitialized_var() is actually suppressing this warning 
> for variables that aren't used.

Yeah.

> I fixed a bug that was attributed to uninitialized var for rc1 
> in 43385846968b ("fs, xattr: fix bug when removing a name not 
> in xattr list"), so thanks very much for removing it entirely.

Ok - looks like everyone is happy with this version - I'll send 
a refreshed version of this patch to Linus near the end of the 
v3.8 merge window.

Note, I won't push it out into linux-next for much of the 
development window (or at all), as there's very little gain from 
all the interaction and churn this would cause with various 
trees, nor does it seem necessary to split it up into a hundred 
small patches. We'll just pull the trigger before v3.8-rc1 with 
one well-tested patch and that's it.

Unless Linus objects to this workflow.

Thanks,

	Ingo
