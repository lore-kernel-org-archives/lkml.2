Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2AWPwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab2AWPwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:52:21 -0500
Date: Mon, 23 Jan 2012 10:52:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123155216.GF25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123153913.GB12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:39:13AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 23, 2012 at 10:20:55AM -0500, Vivek Goyal wrote:
> > What happens to per device rules (per device weight and per device
> > throttling rules)? IIUC, in new scheme of things, upon elevator switch
> > these rules will be gone.
> > 
> > I can understand per device weight rules disappearing but what about 
> > throttling rules. They are independent of IO scheduler and change of
> > io scheduler should not cause per device throttling rules to get lost.
> > 
> > This just gets worse if elevator switch fails and we fall back to old
> > elevator. But now we have lost of the rules as rules were part of
> > blkg.conf and old groups are gone.
> 
> As any other choices, it's about trade off and there multiple aspects
> to consider.  Both elevator and policy changes are extremely low
> frequency and inherently disruptive operations and having persistency
> across them doesn't justify adding the amount of complexity and design
> convolutions we have now, especially not when rule persistency across
> those switches can be implemented with mostly trivial switching script
> from userland.

Atleast throttling rules should not disappear over elevator switch. They
are per device and not per IO scheduler. Think of losing nr_requests
settings just because elevator switch happened.

Elevator switch can be low frequency but how would a user space know
that elevator switch failed that's why we lost our rules and now lets
put the rules back.

I am not sure how would we justify this that because of ease of programming
in kernel, now user space is supposed to make sure that any programmed
rules are still there and reprogram the cgroup if rules are gone for
some reason.

Thanks
Vivek 
