Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1BORCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:02:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1BORB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:01:58 -0500
Date: Tue, 15 Feb 2011 18:01:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
Message-ID: <20110215170152.GF5935@random.random>
References: <20110209195406.B9F23C9F@kernel>
 <20110215165510.GA2550@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215165510.GA2550@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:55:10AM -0500, Eric B Munson wrote:
> I am noticing in smaps that KernelPageSize is wrong of areas
> that have been merged into THP.  For instance:
> 
> 7ff852a00000-7ff852c00000 rw-p 00000000 00:00 0 
> Size:               2048 kB
> Rss:                2048 kB
> Pss:                2048 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:      2048 kB
> Referenced:         2048 kB
> Anonymous:          2048 kB
> AnonHugePages:      2048 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> 
> The entire mapping is contained in a THP but the
> KernelPageSize shows 4kb.  For cases where the mapping might
> have mixed page sizes this may be okay, but for this
> particular mapping the 4kb page size is wrong.

I'm not sure this is a bug, if the mapping grows it may become 4096k
but the new pages may be 4k. There's no such thing as a
vma_mmu_pagesize in terms of hugepages because we support graceful
fallback and collapse/split on the fly without altering the vma. So I
think 4k is correct here.

