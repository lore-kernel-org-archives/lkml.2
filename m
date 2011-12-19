Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1LSOJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:09:45 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42945 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1LSOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:09:43 -0500
Message-ID: <1324303755.2726.4.camel@br98xy6r>
Subject: Re: [PATCH] panic: Don't print redundant backtraces on oops
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 19 Dec 2011 15:09:15 +0100
In-Reply-To: <20111216165207.cc75af5c.akpm@linux-foundation.org>
References: <1323304603-27895-1-git-send-email-andi@firstfloor.org>
	 <20111216165207.cc75af5c.akpm@linux-foundation.org>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121914-4966-0000-0000-000000E8F104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Fri, 2011-12-16 at 16:52 -0800, Andrew Morton wrote:
> On Wed,  7 Dec 2011 16:36:43 -0800
> Andi Kleen <andi@firstfloor.org> wrote:

[snip]

> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -78,7 +78,8 @@ NORET_TYPE void panic(const char * fmt, ...)
> >  	va_end(args);
> >  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> >  #ifdef CONFIG_DEBUG_BUGVERBOSE
> > -	dump_stack();
> > +	if (!oops_in_progress)
> > +		dump_stack();
> >  #endif
> 
> This is kinda related to Michael's
> kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch, below.
> 
> afacit Michael's patch will prevent panic-within-panic, and it does
> this by accident becasue we never thought about it.  But it won't fix
> panic-within-other-oops.
> 
> Is there some clever way in which we can satisfy both requirements in
> one hit?

I think the two problems are not related. My problem was that only one
CPU should execute panic. Andi's problem is that one (or more oops)
messages are scrolled away by a subsequent panic.

But I am not sure if Andi's patch solves all his problems. What e.g.
about panic_on_oom? Don't we have the same problem here?

Michael

