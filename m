Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0LMVP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:15:56 -0500
Received: from mx2.netapp.com ([216.240.18.37]:24354 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0LMVPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:15:55 -0500
X-IronPort-AV: E=Sophos;i="4.59,337,1288594800"; 
   d="scan'208";a="494429316"
Subject: Re: [PATCH 29/35] nfs: in-commit pages accounting and wait queue
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101213150329.831955132@intel.com>
References: <20101213144646.341970461@intel.com>
	 <20101213150329.831955132@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Mon, 13 Dec 2010 16:15:51 -0500
Message-ID: <1292274951.8795.28.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 13 Dec 2010 21:15:52.0916 (UTC) FILETIME=[EC737940:01CB9B0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:47 +0800, Wu Fengguang wrote:
> plain text document attachment (writeback-nfs-in-commit.patch)
> When doing 10+ concurrent dd's, I observed very bumpy commits submission
> (partly because the dd's are started at the same time, and hence reached
> 4MB to-commit pages at the same time). Basically we rely on the server
> to complete and return write/commit requests, and want both to progress
> smoothly and not consume too many pages. The write request wait queue is
> not enough as it's mainly network bounded. So add another commit request
> wait queue. Only async writes need to sleep on this queue.
> 

I'm not understanding the above reasoning. Why should we serialise
commits at the per-filesystem level (and only for non-blocking flushes
at that)?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

