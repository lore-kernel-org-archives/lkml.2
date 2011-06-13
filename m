Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1FMVmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:42:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1FMVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:41:59 -0400
Date: Mon, 13 Jun 2011 17:41:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110613214154.GL633@redhat.com>
References: <20110609141451.GD29913@redhat.com>
 <4DF0DD0F.8090407@tao.ma>
 <20110609153738.GF29913@redhat.com>
 <4DF0EA55.10209@tao.ma>
 <20110609182706.GG29913@redhat.com>
 <4DF1B035.7080009@tao.ma>
 <20110610091427.GB4183@redhat.com>
 <4DF1EB45.1070706@tao.ma>
 <20110610154414.GA31853@redhat.com>
 <4DF5E1A8.7080100@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF5E1A8.7080100@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 06:08:40PM +0800, Tao Ma wrote:

[..]
> > You can also run iostat on disk and should be able to see that with
> > the patch you are dispatching writes more often than before.
> Sorry, the patch doesn't work.
> 
> I used trace event to capture all the blktraces since it doesn't
> interfere with the tests, hope it helps.

Actually I was looking for CFQ traces. This seems to be generic block
layer trace points. May be you can use "blktrace -d /dev/<device>"
and then blkparse. It also gives the aggregate view which is helpful.

> 
> Please downloaded it from http://blog.coly.li/tmp/blktrace.tar.bz2

What concerns me is following.

5255.521353: block_rq_issue: 8,0 W 0 () 571137153 + 8 [attr_set]
5578.863871: block_rq_issue: 8,0 W 0 () 512950473 + 48 [kworker/0:1]

IIUC, we dispatched second write more than 300 seconds after dispatching
1 write. What happened in between. We should have dispatched more writes.

CFQ traces might give better idea in terms of whether wl_type for async
queues was scheduled or not at all.

Thanks
Vivek
