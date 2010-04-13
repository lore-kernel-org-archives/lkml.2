Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0DMSPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:15:32 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38109 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0DMSPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:15:31 -0400
Date: Tue, 13 Apr 2010 20:15:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       nauman@google.com, ctalbott@google.com
Subject: Re: [PATCH][v2] Changes to more io-controller stats patches to
	address review comments.
Message-ID: <20100413181528.GC27497@kernel.dk>
References: <20100412184046.23784.27365.stgit@austin.mtv.corp.google.com> <20100412221158.GB3224@redhat.com> <w2naf41c7c41004131026s3b81d78cl6003df56c32da992@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w2naf41c7c41004131026s3b81d78cl6003df56c32da992@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13 2010, Divyesh Shah wrote:
> Hi Jens,
>        If this looks ok to you, can you please queue it up? Btw, after
> Gui's patches there is 1 merge conflict in your for-2.6.35 branch when
> applying this patch but it seems pretty straightforward to resolve. In
> case you'd prefer a clean patch that takes care of the merge conflict
> please let me know.

I hand applied that one hunk, and committed it.

But...

block/blk-cgroup.c:271: error: redefinition of ?blkiocg_set_start_empty_time?
block/blk-cgroup.h:208: note: previous definition of ?blkiocg_set_start_empty_time? was here
block/blk-cgroup.c: In function ?blkiocg_set_start_empty_time?:
block/blk-cgroup.c:291: error: implicit declaration of function ?blkio_blkg_empty?
block/blk-cgroup.c:292: error: ?struct blkio_group_stats? has no member named ?start_empty_time?
block/blk-cgroup.c:293: error: implicit declaration of function ?blkio_mark_blkg_empty?
make[1]: *** [block/blk-cgroup.o] Error 1
make: *** [block] Error 2

I merged mainline into for-2.6.35 to resolve a merge conflict, but that
was trivial.

-- 
Jens Axboe

