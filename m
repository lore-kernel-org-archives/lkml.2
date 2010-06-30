Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0F3NHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:07:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34748 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0F3NHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:07:41 -0400
Date: Wed, 30 Jun 2010 09:05:04 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 13/14] fs,btrfs: Allow kswapd to writeback pages
Message-ID: <20100630130504.GT1993@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christoph Hellwig <hch@infradead.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
 <1277811288-5195-14-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277811288-5195-14-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C2B4159.00F9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 12:34:47PM +0100, Mel Gorman wrote:
> As only kswapd and memcg are writing back pages, there should be no
> danger of overflowing the stack. Allow the writing back of dirty pages
> in btrfs from the VM.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Signed-off-by: Chris Mason <chris.mason@oracle.com>

But, this is only the metadata writepage.  fs/btrfs/inode.c has another
one for data pages.  (just look for PF_MEMALLOC).

-chris
