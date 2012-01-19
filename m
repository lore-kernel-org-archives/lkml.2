Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2ASPob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:44:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49875 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ASPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:44:26 -0500
Date: Thu, 19 Jan 2012 07:44:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] elevator: make elevator_init_fn() return 0/-errno
Message-ID: <20120119154421.GB5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-5-git-send-email-tj@kernel.org>
 <20120119111151.GC2649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119111151.GC2649@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 06:11:51AM -0500, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 05:11:22PM -0800, Tejun Heo wrote:
> > elevator_ops->elevator_init_fn() has a weird return value.  It returns
> > a void * which the caller should assign to q->elevator->elevator_data
> > and %NULL return denotes init failure.
> > 
> > Update such that it returns integer 0/-errno and sets elevator_data
> > directly as necessary.
> 
> kmalloc() does the same thing. returning pointer means success and null
> means failure.

Yes, allocation functions usually do that.  elevator_init_fn() isn't
exactly one.  It could be but not necessarily so.  Look at the
elevator init wrapper in elevator.c.  We shouldn't need something like
that.

> Also elevator initialization might not necessarily mean that you are
> the active elevator. So cfq_init_queue() assuming that I am the active
> elevator and setting up q->elevator->elevator_data sounds odd to me.

That was changed by the elvator switch sequence update earlier in this
series.

We need this change to use common blkg code for root blkg init.

Thanks.

-- 
tejun
