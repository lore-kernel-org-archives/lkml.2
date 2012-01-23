Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2AWQ2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:28:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2AWQ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:28:44 -0500
Date: Mon, 23 Jan 2012 11:28:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123162840.GJ25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161308.GH25986@redhat.com>
 <20120123162035.GF12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123162035.GF12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 08:20:35AM -0800, Tejun Heo wrote:
> On Mon, Jan 23, 2012 at 11:13:08AM -0500, Vivek Goyal wrote:
> > How about draining throttle groups only on queue exit (blk_cleanup_queue())
> > and not on elevator switch.
> 
> It's for possible policy changes and to fully manage blkg from blkcg.
> blkg itself needs to change as applied policies change and need to be
> flushed.

Can we avoid integrating everything into single blkg. What's wrong with
separate blkg for separage policy. In this case we just don't have the
flexbility to change throttling policy. If it is compiled in, it gets
activated. The only configurable thing is IO scheduler and these groups
will be cleaned up.

So keeping blkg separate for separate policy gives us this flexibility
that we don't have to cleanup throttling data and keep the throttling
rules persistent across elevator switch.

Thanks
Vivek
