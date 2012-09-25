Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2IYTkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:40:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2IYTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:40:22 -0400
Date: Tue, 25 Sep 2012 12:40:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 memstick: support for legacy sony memsticks
Message-ID: <20120925194017.GK16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
 <20120925180235.GC16296@google.com>
 <1348601679.12068.17.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348601679.12068.17.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 09:34:39PM +0200, Maxim Levitsky wrote:
> But this just adds the WQ_UNBOUND. Dunno, without lock I had several
> crashes, that for high level of confidence caused by by parallel
> execution of work items. Once I added this mutex, I couldnt reproduce
> these.

Yes the combination of WQ_UNBOUND and max_active==1 guarantees
strictly ordered one-by-one execution.

> I had the __blk_end_request fail with NULL msb->req. I can't see how
> that can happen if work queue isn't executed in parallel.
> (and then the I didn't even had by mistake the code that sets it to NULL
> in msb_stop, so I really fail to see how that could happen due internal
> bug in my code. 

If you're seeing parallel execution w/ ordered workqueue, it is a
critical bug which would make the kernel crash left and right.  Please
try alloc_ordered_workqueue() and if you still see parallel execution,
please report.

Thanks.

-- 
tejun
