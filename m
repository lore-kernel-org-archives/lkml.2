Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2IQOjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:39:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56888 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2IQOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:39:49 -0400
Date: Mon, 17 Sep 2012 16:39:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120917143943.GB16230@one.firstfloor.org>
References: <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com> <1347680006.4340.142.camel@marge.simpson.net> <m24nmzz2f8.fsf@firstfloor.org> <1347727001.7029.37.camel@marge.simpson.net> <20120915223212.4174a314@pyramind.ukuu.org.uk> <1347770100.6952.31.camel@marge.simpson.net> <CA+55aFwTd+Nde=RfthE5XwFqGfZKVKKd9JfAeDUmwed1E634rQ@mail.gmail.com> <1347869299.6955.156.camel@marge.simpson.net> <20120917100759.GB32463@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917100759.GB32463@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIRC mysql does this properly and outperforms postgresql

Properly = futexes?

It depends on the MySQL engine. Last time I looked InnoDB 
did use custom spinlocks too.  Some of the other MySQL
engines seem to use adaptive pthread mutexes in glibc, but those
have their problems too.

In general unfortunately MySQL is not a single load, it's more 
like a wide range of loads depending on the underlying storage engine.
PostgreSQL at least is more consistent in its problems.

-Andi

