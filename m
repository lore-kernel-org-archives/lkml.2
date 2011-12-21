Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1LUTLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1LUTLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:11:35 -0500
Date: Wed, 21 Dec 2011 14:11:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111221191117.GA27789@redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 10:00:48AM +0900, Minchan Kim wrote:
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

May be using deadline or noop in guest is better to benchmark against
PCI-E based flash.

Thanks
Vivek
