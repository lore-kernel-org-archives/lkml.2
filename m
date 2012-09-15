Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab2IOELK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 00:11:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54553 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750740Ab2IOELI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 00:11:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1++t0gFASW+D45fbm0NDypLkAYOHN/OHNhKC3C1T9
	9fEWiUDRFZRXGX
Message-ID: <1347682262.4340.160.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 06:11:02 +0200
In-Reply-To: <20120914212717.GA29307@liondog.tnic>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 23:27 +0200, Borislav Petkov wrote: 
> (Adding everybody to CC and leaving the below for reference.)
> 
> Guys,
> 
> as Nikolay says below, we have a regression in 3.6 with pgbench's
> benchmark in postgresql.
> 
> I was able to reproduce it on another box here and did a bisection run.
> It pointed to the commit below.
> 
> And yes, reverting that commit fixes the issue here.

My wild (and only) theory is that this is userspace spinlock related.
If so, starting the server and benchmark SCHED_BATCH should not only
kill the regression, but likely improve throughput as well.

-Mike

