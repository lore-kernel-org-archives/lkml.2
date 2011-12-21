Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1LUF5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:57:01 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62586 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LUF46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:56:58 -0500
Date: Wed, 21 Dec 2011 14:56:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111221055648.GC28505@barrios-laptop.redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <87mxamjyvg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxamjyvg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Dec 21, 2011 at 03:38:03PM +1030, Rusty Russell wrote:
> On Wed, 21 Dec 2011 10:00:48 +0900, Minchan Kim <minchan@kernel.org> wrote:
> > This patch is follow-up of Christohp Hellwig's work
> > [RFC: ->make_request support for virtio-blk].
> > http://thread.gmane.org/gmane.linux.kernel/1199763
> > 
> > Quote from hch
> > "This patchset allows the virtio-blk driver to support much higher IOP
> > rates which can be driven out of modern PCI-e flash devices.  At this
> > point it really is just a RFC due to various issues."
> > 
> > I fixed race bug and add batch I/O for enhancing sequential I/O,
> > FLUSH/FUA emulation.
> > 
> > I tested this patch on fusion I/O device by aio-stress.
> > Result is following as.
> > 
> > Benchmark : aio-stress (64 thread, test file size 512M, 8K io per IO, O_DIRECT write)
> > Environment: 8 socket - 8 core, 2533.372Hz, Fusion IO 320G storage
> > Test repeated by 20 times
> > Guest I/O scheduler : CFQ
> > Host I/O scheduler : NOOP
> > 
> >             Request            	BIO(patch 1-4)          BIO-batch(patch 1-6)
> >          (MB/s)  stddev 	(MB/s)  stddev  	(MB/s)  stddev
> > w        737.820 4.063  	613.735 31.605  	730.288 24.854
> > rw       208.754 20.450 	314.630 37.352  	317.831 41.719
> > r        770.974 2.340  	347.483 51.370  	750.324 8.280
> > rr       250.391 16.910 	350.053 29.986  	325.976 24.846
> 
> So, you dropped w and r down 2%, but rw and rr up 40%.
> 
> If I knew what the various rows were, I'd have something intelligent to
> say, I'm sure :)

Sorry for missing that.

w: Sequential Write
rw: Random Write
r: Sequential Read
rr: Random Read

> 
> I can find the source to aio-stress, but no obvious clues.
> 
> Help!
> Rusty.

-- 
Kind regards,
Minchan Kim
