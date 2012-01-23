Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2AWScM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2AWScL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:32:11 -0500
Date: Mon, 23 Jan 2012 13:32:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123183207.GL25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123171049.GH12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:10:49AM -0800, Tejun Heo wrote:

[..]
> No matter what we do for #2, #1 requires ordering between policy
> selection and configuration.  You're saying that #2, combined with the
> fact that blk-throtl can't be built as module or disabled on runtime,
> allows side-stepping the issue for at least blk-throtl.  That doesn't
> sound like a good idea to me.  People are working on different
> elevators implementing different cgroup strategies.  There is no sane
> way around requiring "choosing of policies" to happen before
> "configuration of chosen policies".

This is not just specific to blk-throttle. If in future throttling policy
is removable like elevator, then it will be fine to reset the throttling
related configuration upon removal of throttling policy. But resetting
throttling configuration without policy going anywhere does not sound good.

Thanks
Vivek
