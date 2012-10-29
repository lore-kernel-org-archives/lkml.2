Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab2J2SzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:55:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52327 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab2J2SzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:55:08 -0400
Date: Mon, 29 Oct 2012 11:55:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Minyard <cminyard@mvista.com>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH v2] Remove uninitialized_var()
In-Reply-To: <20121028102007.GA7547@gmail.com>
Message-ID: <alpine.DEB.2.00.1210291150470.10845@chino.kir.corp.google.com>
References: <1350420820-7156-1-git-send-email-minyard@acm.org> <1350420820-7156-5-git-send-email-minyard@acm.org> <20121022164902.9b204646.akpm@linux-foundation.org> <508AE611.3020504@mvista.com> <CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com>
 <20121027131203.GA27313@gmail.com> <20121027114836.e9a6a922.akpm@linux-foundation.org> <20121028102007.GA7547@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012, Ingo Molnar wrote:

> I left it a bit mystic because in some cases this macro was 
> mis-used not to suppress GCC being wrong, but to hide GCC being 
> *right*: for example unused variable warnings in cases like:
> 
>    int uninitialized_var(var);
> 
>    #ifdef XYZ
>    var = ...;
>    ...
>    #endif
> 
> which (ab-)use was no doubt actively dangerous beyond being 
> ugly. One such example is in arch/x86/mm/numa.c. (These cases 
> now turn into clear (and always harmless) compiler warnings, as 
> they should.)
> 

I like initializing them to 0 or NULL because it will still emit the 
"unused variable" warnings whereas using uninitialized_var() would not 
with -Wall.  It's quite possible that uninitialized_var() is actually 
suppressing this warning for variables that aren't used.

I fixed a bug that was attributed to uninitialized var for rc1 in 
43385846968b ("fs, xattr: fix bug when removing a name not in xattr 
list"), so thanks very much for removing it entirely.
