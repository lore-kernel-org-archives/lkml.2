Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2JPX1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:27:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60973 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2JPX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:27:11 -0400
Date: Tue, 16 Oct 2012 16:27:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121016232706.GI16166@google.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robin.

On Tue, Oct 09, 2012 at 02:53:45PM +0800, Robin Dong wrote:
> Currently, if the IO is throttled by io-throttle, the SA has no idea of
> the situation and can't report it to the real application user about

Please don't use "SA" in the commit message.  Just write it out as
"system admin" or "userspace" or whatever.  It's only gonna confuse
people trying to understand the commit later on.

> that he/she has to do something. So this patch adds a new interface
> named blkio.throttle.io_queued which indicates how many IOs are
> currently throttled.
> 
> The nr_queued[] of struct throtl_grp is of type "unsigned int" and updates
> to it are atomic both at 32bit and 64bit platforms, so we could just
> read tg->nr_queued only under blkcg->lock.
> 
> Changelog from v2:
> 	Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.

As I wrote last time, I would prefer exposing the total number queued
to blk-throttle rather than exposing the number of bios being
currently held and let userland calculate from the difference from
throttle.io_serviced.  That is simpler and more inline with all other
stats.

Thanks.

-- 
tejun
