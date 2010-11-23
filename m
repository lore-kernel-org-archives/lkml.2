Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0KWOzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:55:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37847 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0KWOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=hNwoMp+7Mwi6r1ZadSrsL7uAzUOk5bKhML5dsq4eUDGKxxc9gZ5nNQdZ5j0Y8EGQYk
         sFKElY1zIVJrdZeAh90xPbBygOJRbPLY/frkPTUxCXCjQFRLF1PzW0SADxxLftB6k6AF
         teKlKIxqquJA4C+0Q2gW0YI8NS1wRoqj21Qhc=
From: Ben Gamari <bgamari@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
In-Reply-To: <20101123093859.GE19571@csn.ul.ie>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <20101122141449.9de58a2c.akpm@linux-foundation.org> <AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com> <20101122210132.be9962c7.akpm@linux-foundation.org> <20101123093859.GE19571@csn.ul.ie>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Nov 2010 09:55:49 -0500
Message-ID: <87k4k49jii.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 09:38:59 +0000, Mel Gorman <mel@csn.ul.ie> wrote:
> > If it's mapped pagecache then the user was being a bit silly (or didn't
> > know that some other process had mapped the file).  In which case we
> > need to decide what to do - leave the page alone, deactivate it, or
> > half-deactivate it as this patch does.
> > 
> 
> What are the odds of an fadvise() user having used mincore() in advance
> to determine if the page was in use by another process? I would guess
> "low" so this half-deactivate gives a chance for the page to be promoted
> again as well as a chance for the flusher threads to clean the page if
> it really is to be reclaimed.
> 
Do we really want to make the user jump through such hoops as using
mincore() just to get the kernel to handle use-once pages properly?
I hope the answer is no. I know that fadvise isn't supposed to be a
magic bullet, but it would be nice if more processes would use it to
indicate their access patterns and the only way that will happen is if
it is reasonably straightforward to use.

- Ben
