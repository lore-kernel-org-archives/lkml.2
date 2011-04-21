Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1DUEjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:39:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1DUEjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:39:45 -0400
Date: Thu, 21 Apr 2011 00:39:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/6] writeback: try more writeback as long as something
 was written
Message-ID: <20110421043940.GC22423@infradead.org>
References: <20110419030003.108796967@intel.com>
 <20110419030532.778889102@intel.com>
 <20110419102016.GD5257@quack.suse.cz>
 <20110419111601.GA18961@localhost>
 <20110419211008.GD9556@quack.suse.cz>
 <20110420075053.GB30672@localhost>
 <20110420152211.GC4991@quack.suse.cz>
 <20110421033325.GA13764@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421033325.GA13764@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 11:33:25AM +0800, Wu Fengguang wrote:
> I collected the writeback_single_inode() traces (patch attached for
> your reference) each for several test runs, and find much more
> I_DIRTY_PAGES after patchset. Dave, do you know why there are so many
> I_DIRTY_PAGES (or radix tag) remained after the XFS ->writepages() call,
> even for small files?

What is your defintion of a small file?  As soon as it has multiple
extents or holes there's absolutely no way to clean it with a single
writepage call.  Also XFS tries to operate as non-blocking as possible
if the non-blocking flag is set in the wbc, but that flag actually
seems to be dead these days.

