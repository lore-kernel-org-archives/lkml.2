Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2IOEmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 00:42:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42970 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750720Ab2IOEmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 00:42:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18t7OFf+4ktqCypWCRmZPZjR0BO5WOlD7uOnctpXG
	6ufUwtpMmoGe2G
Message-ID: <1347684137.4340.166.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 15 Sep 2012 06:42:17 +0200
In-Reply-To: <CA+55aFz1A7HbMYS9o-GTS5Zm=Xx8MUD7cR05GMVo--2E34jcgQ@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <1347682262.4340.160.camel@marge.simpson.net>
	 <CA+55aFz1A7HbMYS9o-GTS5Zm=Xx8MUD7cR05GMVo--2E34jcgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 21:15 -0700, Linus Torvalds wrote:
> We don't do random crazy "use another scheduler" to hide problems with
> the default one.

I was proposing a diagnostic.
> 
> And since you are the author of the regressing patch, and don't seem
> to treat the regression as something serious, I really see no
> alternative to just reverting it.

Wow, I don't know how you obtained that impression, but fine, nuke it.

>       Linus
> 
> On Sep 14, 2012 9:11 PM, "Mike Galbraith" <efault@gmx.de> wrote:
>         On Fri, 2012-09-14 at 23:27 +0200, Borislav Petkov wrote:
>         > (Adding everybody to CC and leaving the below for
>         reference.)
>         >
>         > Guys,
>         >
>         > as Nikolay says below, we have a regression in 3.6 with
>         pgbench's
>         > benchmark in postgresql.
>         >
>         > I was able to reproduce it on another box here and did a
>         bisection run.
>         > It pointed to the commit below.
>         >
>         > And yes, reverting that commit fixes the issue here.
>         
>         My wild (and only) theory is that this is userspace spinlock
>         related.
>         If so, starting the server and benchmark SCHED_BATCH should
>         not only
>         kill the regression, but likely improve throughput as well.
>         
>         -Mike
>         


