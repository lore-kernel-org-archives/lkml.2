Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722Ab2FVVjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2FVVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:39:05 -0400
Date: Fri, 22 Jun 2012 14:39:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds
 pages to the buddy allocator again
Message-Id: <20120622143903.ea1c6484.akpm@linux-foundation.org>
In-Reply-To: <CAHGf_=rQ6AaZBjfvkWWKi+a5q+1R29_PGWDyD77VFisgJHPQEA@mail.gmail.com>
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
	<20120622131901.28f273e3.akpm@linux-foundation.org>
	<CAHGf_=rQ6AaZBjfvkWWKi+a5q+1R29_PGWDyD77VFisgJHPQEA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 17:10:59 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> On Fri, Jun 22, 2012 at 4:19 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 14 Jun 2012 12:16:10 -0400
> > kosaki.motohiro@gmail.com wrote:
> >
> >> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
> >> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
> >> another miuse still exist.
> >
> > This changelog is irritating. __One can understand it a bit if one
> > happens to have a git repo handy (and why do this to the reader?), but
> > the changelog for 2ff754fa8f indicates that the patch might fix a
> > livelock. __Is that true of this patch? __Who knows...
> 
> The code in this simple patch speak the right usage, isn't it?

It depends who is listening.

Please, put yourself in the position of poor-scmuck@linux-distro.com
who is reading your patch and wondering whether it will fix some
customer bug report he is working on.  Or wondering whether he should
backport it into his company's next kernel release.  He simply won't be
able to do this with the information which was provided here.  And if
we don't tell him, who will?

> And yes,
> this patch also fixes a possibility of live lock. (but i haven't seen actual
> live lock cause from this mistake)

hrm, I guess I'll put it in the 3.6 pile.
