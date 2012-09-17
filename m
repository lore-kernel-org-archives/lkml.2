Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2IQWPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:15:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2IQWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:15:33 -0400
Date: Mon, 17 Sep 2012 15:15:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v10 0/5] make balloon pages movable by compaction
Message-Id: <20120917151531.e9ac59f2.akpm@linux-foundation.org>
In-Reply-To: <cover.1347897793.git.aquini@redhat.com>
References: <cover.1347897793.git.aquini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 13:38:15 -0300
Rafael Aquini <aquini@redhat.com> wrote:

> Memory fragmentation introduced by ballooning might reduce significantly
> the number of 2MB contiguous memory blocks that can be used within a guest,
> thus imposing performance penalties associated with the reduced number of
> transparent huge pages that could be used by the guest workload.
> 
> This patch-set follows the main idea discussed at 2012 LSFMMS session:
> "Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/
> to introduce the required changes to the virtio_balloon driver, as well as
> the changes to the core compaction & migration bits, in order to make those
> subsystems aware of ballooned pages and allow memory balloon pages become
> movable within a guest, thus avoiding the aforementioned fragmentation issue
> 
> Following are numbers that prove this patch benefits on allowing compaction
> to be more effective at memory ballooned guests.
> 
> Results for STRESS-HIGHALLOC benchmark, from Mel Gorman's mmtests suite,
> running on a 4gB RAM KVM guest which was ballooning 1gB RAM in 256mB chunks,
> at every minute (inflating/deflating), while test was running:

How can a patchset reach v10 and have zero Reviewed-by's?

The patchset looks reasonable to me and your empirical results look
good.  But I don't feel that I'm in a position to decide on its overall
desirability, either in a standalone sense or in comparison to any
alternative schemes which anyone has proposed.

IOW, Rusty and KVM folks: please consider thyself poked.

I looked through the code and have some comments which are minor in the
overall scheme of things.  I'll be more comfortable when a compaction
expert has had a go over it.  IOW, Mel joins the pokee list ;)

(The question of "overall desirability" is the big one here.  Do we
actually want to add this to Linux?  The rest is details which we can
work out).


