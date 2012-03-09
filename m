Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2CICH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:07:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56683 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2CICH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:07:26 -0500
Date: Thu, 8 Mar 2012 18:06:50 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon
 filter
In-Reply-To: <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1203081758490.18195@eggly.anvils>
References: <20120229091547.29236.28230.stgit@zurg> <20120303091327.17599.80336.stgit@zurg> <alpine.LSU.2.00.1203061904570.18675@eggly.anvils> <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, KAMEZAWA Hiroyuki wrote:
> On Tue, 6 Mar 2012 19:22:21 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> > 
> > What does the compiler say (4.5.1 here, OPTIMIZE_FOR_SIZE off)?
> >    text	   data	    bss	    dec	    hex	filename
> >   17723	    113	     17	  17853	   45bd	vmscan.o.0
> >   17671	    113	     17	  17801	   4589	vmscan.o.1
> >   17803	    113	     17	  17933	   460d	vmscan.o.2
> > 
> > That suggests that your v2 is the worst and your v1 the best.
> > Kame, can I persuade you to let the compiler decide on this?
> > 
> 
> Hmm. How about Costa' proposal ? as
> 
> int tmp_var = PageActive(page) ? ISOLATE_ACTIVE : ISOLATE_INACTIVE
> if (!(mode & tmp_var))
>     ret;

Yes, that would have been a good compromise (given a better name
than "tmp_var"!), I didn't realize that one was acceptable to you.

But I see that Konstantin has been inspired by our disagreement to a
more creative solution.

I like very much the look of what he's come up with, but I'm still
puzzling over why it barely makes any improvement to __isolate_lru_page():
seems significantly inferior (in code size terms) to his original (which
I imagine Glauber's compromise would be equivalent to).

At some point I ought to give up on niggling about this,
but I haven't quite got there yet.

Hugh
