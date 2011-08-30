Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1H3WzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:55:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab1H3WzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:18 -0400
Date: Tue, 30 Aug 2011 15:54:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-Id: <20110830155438.bc31ab99.akpm@linux-foundation.org>
In-Reply-To: <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
	<4E5D5817.6040704@kernel.dk>
	<CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
	<4E5D64E8.7000102@kernel.dk>
	<20110830154157.d802d097.akpm@linux-foundation.org>
	<CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 15:45:35 -0700
Daniel Ehrenberg <dehrenberg@google.com> wrote:

> >> Not quite sure, and after working on them and fixing thing up, I don't
> >> even think they are that complex or intrusive (which I think otherwise
> >> would've been the main objection). Andrew may know/remember.
> >
> > Boy, that was a long time ago. __I was always unhappy with the patches
> > because of the amount of additional code/complexity they added.
> >
> > Then the great syslets/threadlets design session happened and it was
> > expected that such a facility would make special async handling for AIO
> > unnecessary. __Then syslets/threadlets didn't happen.
> 
> Do you think we could accomplish the goals with less additional
> code/complexity? It looks like the latest version of the patch set
> wasn't so invasive.
> 
> If syslets/threadlets aren't happening, should these patches be
> reconsidered for inclusion in the kernel?

I haven't seen any demand at all for the feature in many years.  That
doesn't mean that there _isn't_ any demand - perhaps everyone got
exhausted.

If there is demand then that should be described and circulated, see
how much interest there is in resurrecting the effort.

And, of course, the patches should be dragged out and looked at - it's
been a number of years now.

Also, glibc has userspace for POSIX AIO.  A successful kernel-based
implementation would result in glibc migrating away from its current
implementation.  So we should work with the glibc developers on ensuring
that the migration can happen.

