Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1FTQ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:59:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51531 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1FTQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:59:51 -0400
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <1308587683-2555-2-git-send-email-amwang@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
	 <1308587683-2555-2-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 09:59:23 -0700
Message-ID: <1308589163.11430.245.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 00:34 +0800, Amerigo Wang wrote:
> +config TRANSPARENT_HUGEPAGE_THRESHOLD
> +       depends on TRANSPARENT_HUGEPAGE
> +       int "The minimal threshold of enabling Transparent Hugepage"
> +       range 512 8192
> +       default "512"
> +       help
> +         The threshold of enabling Transparent Huagepage automatically,
> +         in Mbytes, below this value, Transparent Hugepage will be disabled
> +         by default during boot. 

It makes some sense to me that there would _be_ a threshold, simply
because you need some space to defragment things.  But, I can't imagine
any kind of user having *ANY* kind of idea what to set this to.  Could
we add some text to this?  Maybe:

        Transparent hugepages are created by moving other pages out of
        the way to create large, contiguous swaths of free memory.
        However, some memory on a system can not be easily moved.  It is
        likely on small systems that this unmovable memory will occupy a
        large portion of total memory, which makes even attempting to
        create transparent hugepages very expensive.
        
        If you are unsure, set this to the smallest possible value.
        
        To override this at boot, use the $FOO boot command-line option.

I'm also not sure putting a ceiling on this makes a lot of sense.
What's the logic behind that?  I know it would be a mess to expose it to
users, but shouldn't this be a per-zone limit, logically?  Seems like a
8GB system would have similar issues to a two-numa-node 16GB system.

-- Dave

