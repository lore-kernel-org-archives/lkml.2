Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2IYTeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:34:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57100 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2IYTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:34:45 -0400
Message-ID: <1348601679.12068.17.camel@maxim-laptop>
Subject: Re: [PATCH v2 memstick: support for legacy sony memsticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 21:34:39 +0200
In-Reply-To: <20120925180235.GC16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
	 <20120925180235.GC16296@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 11:02 -0700, Tejun Heo wrote: 
> Hello,
> 
> > * Swithced to using a workqueue.
> >   Unfortunelly, I still see that workqueue items are executed in parallel
> >   I suspect that this happens if one work item sleeps. In this case I
> >   don't want other work items to run too. I fixed this with a mutex, and anyway
> >   it nice to have it to guaranteee this.
> 
> You can use alloc_ordered_workqueue("namefmt", WQ_MEM_RECLAIM).  No
> mutex needed for inter-work exclusion.
But this just adds the WQ_UNBOUND. Dunno, without lock I had several
crashes, that for high level of confidence caused by by parallel
execution of work items. Once I added this mutex, I couldnt reproduce
these.

I had the __blk_end_request fail with NULL msb->req. I can't see how
that can happen if work queue isn't executed in parallel.
(and then the I didn't even had by mistake the code that sets it to NULL
in msb_stop, so I really fail to see how that could happen due internal
bug in my code. 
> 
> Thanks.
> 

-- 
Best regards,
        Maxim Levitsky


