Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2IPTI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:08:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2IPTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:08:17 -0400
Date: Sun, 16 Sep 2012 12:07:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jiri Slaby <jslaby@suse.cz>
cc: Michel Lespinasse <walken@google.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-mm@kvack.org,
        riel@redhat.com, peterz@infradead.org, aarcange@redhat.com,
        daniel.santos@pobox.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 6/7] mm: add CONFIG_DEBUG_VM_RB build option
In-Reply-To: <505433A0.3010702@suse.cz>
Message-ID: <alpine.LSU.2.00.1209161130460.5591@eggly.anvils>
References: <1346750457-12385-1-git-send-email-walken@google.com> <1346750457-12385-7-git-send-email-walken@google.com> <5053AC2F.3070203@gmail.com> <CANN689Ff3W4z=+3J8aGO-2GrPHGJ=ote_f5q9jzRQRAP+b0T4Q@mail.gmail.com> <20120915000029.GA29426@google.com>
 <505433A0.3010702@suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2012, Jiri Slaby wrote:
> On 09/15/2012 02:00 AM, Michel Lespinasse wrote:
> > All right. Hugh managed to reproduce the issue on his suse laptop, and
> > I came up with a fix.
> > 
> > The problem was that in mremap, the new vma's vm_{start,end,pgoff}
> > fields need to be updated before calling anon_vma_clone() so that the
> > new vma will be properly indexed.
> > 
> > Patch attached. I expect this should also explain Jiri's reported
> > failure involving splitting THP pages during mremap(), even though we
> > did not manage to reproduce that one.
> 
> Oh, great. This is BTW also machine with suse.

We guessed that for you it might be :)
I've not yet moved up from 11.4 by the way, if that makes a difference.

In fact, even before these reports, when Michel was wondering about the
uses of mremap, I did mention an mremap/THP bug from a year ago, which
the SuSE update had been good for reproducing.

> What was the way that
> Hugh used to reproduce the other issue?

I've lost track of which issue is "other".

To reproduce Sasha's interval_tree.c warnings, all I had to do was switch
on CONFIG_DEBUG_VM_RB (I regret not having done so before) and boot up.

I didn't look to see what was doing the mremap which caused the warning
until now: surprisingly, it's microcode_ctl.  I've not made much effort
to get the right set of sources and work out why that would be using
mremap (a realloc inside a library?).

I failed to reproduce your BUG in huge_memory.c, but what I was trying
was SuSE update via yast2, on several machines; but perhaps because
they were all fairly close to up-to-date, I didn't hit a problem.
(That was before I turned on DEBUG_VM_RB for Sasha's.)

Hugh

> For me it happened twice in a
> row when using zypper to upgrade packages. But it did not happen any
> more after that.
> 
> thanks,
> -- 
> js
> suse labs
