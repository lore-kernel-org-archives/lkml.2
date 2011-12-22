Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1LVPvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:51:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1LVPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:51:08 -0500
Date: Thu, 22 Dec 2011 10:45:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111222154506.GC1388@redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <20111221191117.GA27789@redhat.com>
 <20111222010538.GA9879@barrios-laptop.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222010538.GA9879@barrios-laptop.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:05:38AM +0900, Minchan Kim wrote:

[..]
> > May be using deadline or noop in guest is better to benchmark against
> > PCI-E based flash.
> 
> Good suggestion.
> I tested it by deadline on guest side.
> 
> The result is not good.
> Although gap is within noise, Batch BIO's random performance is regressed
> compared to CFQ. 
> 
>             Request                Batch BIO
> 
>          (MB/s)  stddev          (MB/s)  stddev
> w        787.030 31.494 w        748.714 68.490
> rw       216.044 29.734 rw       216.977 40.635
> r        771.765 3.327  r        771.107 4.299
> rr       280.096 25.135 rr       258.067 43.916
> 
> I did some small test for only Batch BIO with deadline and cfq.
> to see I/O scheduler's effect.
> I think result is very strange, deadline :149MB, CFQ : 87M
> Because Batio BIO patch uses make_request_fn instead of request_rfn.
> So I think we should not affect by I/O scheduler.(I mean we issue I/O 
> before I/O scheduler handles it)
> 
> What do you think about it?
> Do I miss something?

This indeed is very strange. In case of bio based drivers, changing IO
scheduler on the queue should not change anything.

Trying running blktrace on the vda devie and see if you notice something
odd.

Also you seem to be reporting contracdicting results for batch bio.

Initially you mention that random IO is regressing with deadline as
comapred to CFQ. (It dropped from 325.976 MB/s to 258.067 MB/s).

In this second test you are reporting that CFQ performs badly as
compared to deadline. (149MB/s vs 87MB/s).

Two contradicting results?

Thanks
Vivek
