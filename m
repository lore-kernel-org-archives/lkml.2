Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0EXVWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab0EXVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:22:13 -0400
Date: Mon, 24 May 2010 17:22:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace
	backlogged group status
Message-ID: <20100524212207.GC28685@redhat.com>
References: <4BF64712.1070500@cn.fujitsu.com> <20100521131751.GA15302@redhat.com> <4BF9D265.70008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF9D265.70008@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:12:05AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
> >> Hi,
> >>
> >> This series implements three new interfaces to keep track of tranferred bytes,
> >> elapsing time and io rate since group getting backlogged. If the group dequeues
> >> from service tree, these three interfaces will reset and shows zero.
> > 
> > Hi Gui,
> > 
> > Can you give some details regarding how this functionality is useful? Why
> > would somebody be interested in only in stats of till group was
> > backlogged and not in total stats?
> > 
> > Groups can come and go so fast and these stats will reset so many times
> > that I am not able to visualize how these stats will be useful.
> 
> Hi Vivek,
> 
> Currently, we assign weight to a group, but user still doesn't know how fast the
> group runs. With io rate interface, users can check the rate of a group at any
> moment, or to determine whether the weight assigned to a group is enough.
> bytes and time interface is just for debug purpose.

Gui,

I still don't understand that why blkio.sectors or blkio.io_service_bytes
or blkio.io_serviced interfaces are not good enough to determine at what
rate a group is doing IO.

I think we can very well write something in userspace like "iostat" to 
display the per group rate. Utility can read the any of the above files
say at the interfval of 1s, calculate the diff between the values and
display that as group effective rate.

Thanks
Vivek
