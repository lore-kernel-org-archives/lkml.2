Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0KST1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:27:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab0KST1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:27:23 -0500
Date: Fri, 19 Nov 2010 20:26:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02 of 66] mm, migration: Fix race between
 shift_arg_pages and rmap_walk by guaranteeing rmap_walk finds PTEs created
 within the temporary stack
Message-ID: <20101119192601.GG24450@random.random>
References: <patchbomb.1288798055@v2.random>
 <ad7a334318ea379be733.1288798057@v2.random>
 <20101118111349.GG8135@csn.ul.ie>
 <20101119173817.GE24450@random.random>
 <AANLkTin76ajKd5Dc1fYwibqmL9yd6MtEvCWxCYYwnqOU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin76ajKd5Dc1fYwibqmL9yd6MtEvCWxCYYwnqOU@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:54:27AM -0800, Linus Torvalds wrote:
> On Fri, Nov 19, 2010 at 9:38 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > We decided the kmalloc was ok, but Linus didn't like this approach. I
> > kept it in my tree because I didn't want to remember when/if to add the
> > special check in the accurate rmap walks. I find it simpler if all
> > rmap walks are accurate by default.
> 
> Why isn't the existing cheap solution sufficient?

It is sufficient.

> My opinion is still that we shouldn't add the expense to the common
> case, and it's the uncommon case (migration) that should just handle
> it.

Ok, I'll remove this patch from the next submit.
