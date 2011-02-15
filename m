Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1BORFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:05:43 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60167 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1BORFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:05:40 -0500
Subject: Re: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
In-Reply-To: <20110215170152.GF5935@random.random>
References: <20110209195406.B9F23C9F@kernel>
	 <20110215165510.GA2550@mgebm.net>  <20110215170152.GF5935@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 15 Feb 2011 09:05:25 -0800
Message-ID: <1297789525.9829.9616.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 18:01 +0100, Andrea Arcangeli wrote:
> > The entire mapping is contained in a THP but the
> > KernelPageSize shows 4kb.  For cases where the mapping might
> > have mixed page sizes this may be okay, but for this
> > particular mapping the 4kb page size is wrong.
> 
> I'm not sure this is a bug, if the mapping grows it may become 4096k
> but the new pages may be 4k. There's no such thing as a
> vma_mmu_pagesize in terms of hugepages because we support graceful
> fallback and collapse/split on the fly without altering the vma. So I
> think 4k is correct here

How about we bump MMUPageSize for mappings that are _entirely_ huge
pages, but leave it at 4k for mixed mappings?  Anyone needing more
detail than that can use the new AnonHugePages count.

KernelPageSize is pretty ambiguous, and we could certainly make the
argument that the kernel is or can still deal with things in 4k blocks.

-- Dave

