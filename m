Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1JZT3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:29:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1JZT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:29:37 -0400
Date: Wed, 26 Oct 2011 12:29:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] block: make ioc get/put interface more
 conventional and fix race on alloction
Message-ID: <20111026192917.GC24261@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-5-git-send-email-tj@kernel.org>
 <20111026160101.GB355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026160101.GB355@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 26, 2011 at 12:01:01PM -0400, Vivek Goyal wrote:
> We really don't need to create a new io context here if it is not present.
> cgroup_changed is set so that reference to old sync cfqq is dropped and
> a new one is assigned when new IO comes in. Given the fact that io context
> is not even present for the task being attached, there is no way there
> is associated cic and associated cfqq. So no need to set changed_cgroup=1.
> 
> Will it make sense to pass in additional parameter to get_task_io_context()
> so that it takes a reference if ioc exists otherwise returns NULL. Or may
> be another variant of get_task_io_context() function.
> 
> This is a minor issue though. Will just avoid creating iocontext memory
> for task if one is not using CFQ in the system.

Yeah, something like GFP_NOALLOC would have been nice for cases like
this.  That said, adding another param or API for this doesn't sound
too hot to me.  It's an extremely marginal optimization.  Let's just
let it be.

> > +extern char __blk_test_mode[2];
> > +#define blk_test_mode	(__blk_test_mode[0])
> > +
> 
> Looks like leftover of your testing code.

Heh... what does that doing there? :) Will update the patch & git
tree.

Thanks.

-- 
tejun
