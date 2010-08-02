Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0HBIEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:04:10 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17438 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab0HBIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:04:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALIWVkx5LclT/2dsb2JhbACgEHK+foU5BA
Date: Mon, 2 Aug 2010 18:03:53 +1000
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
Message-ID: <20100802080353.GA8713@amd>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
 <1280711334-30000-12-git-send-email-acme@infradead.org>
 <20100802073009.GB7841@amd>
 <20100802075422.GA24085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802075422.GA24085@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:54:22AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Sun, Aug 01, 2010 at 10:08:46PM -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > So that we can reduce the noise on valgrind when looking for memory
> > > leaks.
> > 
> > Really? That's rather crappy of valgrind. exit is well defined to release 
> > resources and that's often a more efficient way to do it It finds and 
> > batches things a lot better, eg. it can avoid all TLB flushing of freeing 
> > memory that munmap requires.
> 
> That's certainly true but there's no valgrind crappiness here: valgrind simply 
> can do a better job of finding leaks if there's a well defined "all resources 
> the app still knows about are freed now" point.

"noise" sounds like false positives though. Certainly if this is
instead allows valgrind to run in a particular mode that assumes
no application resources consumed at exit(2) time, I wouldn't
call it crappy :)

But you could equally sprinkle in other valgrind specific annotations
or semantics at various points in the code to improve its coverage,
no?
