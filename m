Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2IZREp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:04:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62174 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab2IZREo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:04:44 -0400
Date: Wed, 26 Sep 2012 10:04:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and
 start all flusher at the same time
Message-ID: <20120926170439.GS16296@google.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
 <20120924203954.GD29689@google.com>
 <50617333.9020903@cn.fujitsu.com>
 <20120925202427.GM16296@google.com>
 <5062893B.70908@cn.fujitsu.com>
 <20120926164958.GR16296@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926164958.GR16296@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Wed, Sep 26, 2012 at 09:49:58AM -0700, Tejun Heo wrote:
> > The simple version of flush_workqueue() which I sent yesterday is "chained",
> > because it forces overflow flushers wait for free color and forces only one
> > flusher for one color.
> >
> > Since "not chaining" is important/essential. I sent a new draft implement today.
> > it uses multiple queues, one for each color(like SRCU).
> > this version is also simple, it remove 90 LOC.
> 
> I'll review your patch but the current implementation is enough on
> that regard.  I was trying to advise against going for two-color
> scheme.

So, I like it.  Two things.

* I think we still want to optimize noop case.  IOW, please keep the
  early exit path for cases where there's no work item to flush.

* Can you please redo the patch series so that it doesn't go too much
  roundabout?

Thanks.

-- 
tejun
