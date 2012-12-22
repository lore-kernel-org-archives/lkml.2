Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2LVCWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:22:25 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:45205 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2LVCWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:22:23 -0500
Date: Fri, 21 Dec 2012 18:22:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121222022210.GA30177@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221181523.0e0998e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Fri, Dec 21, 2012 at 06:15:23PM -0800, Andrew Morton wrote:
> On Fri, 21 Dec 2012 17:57:15 -0800 Tejun Heo <tj@kernel.org> wrote:
> 
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> 
> > -		if (!work_pending(&ipc_memory_wq))
> > -			schedule_work(&ipc_memory_wq);
> > +		schedule_work(&ipc_memory_wq);
> 
> Well, the new code is a ton slower than the old code if the work is
> frequently pending, so some care is needed with such a conversion.

Yeah, I mentioned it in the head message.  it comes down to
test_and_set_bit() vs. test_bit() and none of the current users seems
to be hot enough for that to matter at all.

In very hot paths, such optimization *could* be valid.  The problem is
that [delayed_]work_pending() seem to be abused much more than they
are put to any actual usefulness.  Maybe we should rename them to
something really ugly.  I don't know.

> That's not an issue for the IPC callsite - memory offlining isn't
> frequent.
> 
> > ...
> >
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> > 
> 
> Please merge this one yourself.

Can I add your acked-by?

Thanks.

-- 
tejun
