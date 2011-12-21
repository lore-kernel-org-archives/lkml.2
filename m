Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1LUFWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:22:09 -0500
Received: from ozlabs.org ([203.10.76.45]:47393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1LUFWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:22:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Minchan Kim <minchan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 21 Dec 2011 15:38:03 +1030
Message-ID: <87mxamjyvg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 10:00:48 +0900, Minchan Kim <minchan@kernel.org> wrote:
> This patch is follow-up of Christohp Hellwig's work
> [RFC: ->make_request support for virtio-blk].
> http://thread.gmane.org/gmane.linux.kernel/1199763
> 
> Quote from hch
> "This patchset allows the virtio-blk driver to support much higher IOP
> rates which can be driven out of modern PCI-e flash devices.  At this
> point it really is just a RFC due to various issues."
> 
> I fixed race bug and add batch I/O for enhancing sequential I/O,
> FLUSH/FUA emulation.
> 
> I tested this patch on fusion I/O device by aio-stress.
> Result is following as.
> 
> Benchmark : aio-stress (64 thread, test file size 512M, 8K io per IO, O_DIRECT write)
> Environment: 8 socket - 8 core, 2533.372Hz, Fusion IO 320G storage
> Test repeated by 20 times
> Guest I/O scheduler : CFQ
> Host I/O scheduler : NOOP
> 
>             Request            	BIO(patch 1-4)          BIO-batch(patch 1-6)
>          (MB/s)  stddev 	(MB/s)  stddev  	(MB/s)  stddev
> w        737.820 4.063  	613.735 31.605  	730.288 24.854
> rw       208.754 20.450 	314.630 37.352  	317.831 41.719
> r        770.974 2.340  	347.483 51.370  	750.324 8.280
> rr       250.391 16.910 	350.053 29.986  	325.976 24.846

So, you dropped w and r down 2%, but rw and rr up 40%.

If I knew what the various rows were, I'd have something intelligent to
say, I'm sure :)

I can find the source to aio-stress, but no obvious clues.

Help!
Rusty.
