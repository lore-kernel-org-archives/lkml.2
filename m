Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2IRLl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:41:56 -0400
Received: from ozlabs.org ([203.10.76.45]:54652 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696Ab2IRLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:41:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v10 0/5] make balloon pages movable by compaction
In-Reply-To: <20120917151531.e9ac59f2.akpm@linux-foundation.org>
References: <cover.1347897793.git.aquini@redhat.com> <20120917151531.e9ac59f2.akpm@linux-foundation.org>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 18 Sep 2012 10:15:59 +0930
Message-ID: <87boh4qhtk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Mon, 17 Sep 2012 13:38:15 -0300
> Rafael Aquini <aquini@redhat.com> wrote:
>> Results for STRESS-HIGHALLOC benchmark, from Mel Gorman's mmtests suite,
>> running on a 4gB RAM KVM guest which was ballooning 1gB RAM in 256mB chunks,
>> at every minute (inflating/deflating), while test was running:
>
> How can a patchset reach v10 and have zero Reviewed-by's?

The virtio_balloon changes are fairly trivial compared to the mm parts,
and Michael Tsirkin provided feedback on the last round.

However, the real trick is figuring out what the locking rules are when
the mm core calls in to ask us about a page.  And that requires someone
who really knows the mm stuff.

> The patchset looks reasonable to me and your empirical results look
> good.  But I don't feel that I'm in a position to decide on its overall
> desirability, either in a standalone sense or in comparison to any
> alternative schemes which anyone has proposed.

It's definitely nice to have, though it's far more complicated than I
would have thought.

Cheers,
Rusty.
