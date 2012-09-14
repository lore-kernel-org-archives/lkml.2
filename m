Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab2INVlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:41:44 -0400
Received: from [205.233.59.134] ([205.233.59.134]:56209 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2INVlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:41:40 -0400
Message-ID: <1347658843.7172.90.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 14 Sep 2012 23:40:43 +0200
In-Reply-To: <20120914212717.GA29307@liondog.tnic>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 23:27 +0200, Borislav Petkov wrote:
> 
> I was able to reproduce it on another box here and did a bisection run.
> It pointed to the commit below.
> 
> And yes, reverting that commit fixes the issue here.

Hmm, cute. What kind of machine did you test it on? Nikolay's machines
look to be smallish AMD X6 or ancient Intel c2d (the patch will indeed
have absolutely no effect on a dual core).

I'll see about running pgbench on a bigger Intel tomorrow if Mike
doesn't beat me to it.

The problem the patch is trying to address is not having to scan an
entire package for idle cores on every wakeup now that packages are
getting stupid big.

Regressing Postgres otoh isn't nice either..

Anyway, I guess I'm fine with nixing this patch until we figure out
something smarter..

I'm also curious to know wth postgres does that this patch makes such a
big difference...
