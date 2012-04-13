Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2DMUrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:47:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab2DMUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:47:15 -0400
Date: Fri, 13 Apr 2012 13:47:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120413204710.GF12233@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413204446.GK26383@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 04:44:46PM -0400, Vivek Goyal wrote:
> On Fri, Apr 13, 2012 at 01:37:26PM -0700, Tejun Heo wrote:
> 
> [..]
> > blk_cleanup_queue() doesn't use blk_queue_bypass_start() to enter
> > bypass mode.
> 
> Oh now elevator_exit() has been moved into blk_release_queue(). But
> problem will still be there, isn't it? During driver init, most likely driver
> is holding last reference of the queue and blk_release_queue() will be called
> in the context of blk_cleanup_queue() causing the overhead?

Hmmm?  blk_cleanup_queue() will put the queue into bypassing mode
without going through synchronize_rcu() and all the following
bypassing operations just inc/decs bypass_depth without any draining
operation.

Thanks.

-- 
tejun
