Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2IYUNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:13:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34455 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab2IYUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:13:20 -0400
Message-ID: <1348603996.12068.19.camel@maxim-laptop>
Subject: Re: [PATCH v2 memstick: support for legacy sony memsticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 22:13:16 +0200
In-Reply-To: <20120925194017.GK16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
	 <20120925180235.GC16296@google.com>
	 <1348601679.12068.17.camel@maxim-laptop>
	 <20120925194017.GK16296@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 12:40 -0700, Tejun Heo wrote: 
> On Tue, Sep 25, 2012 at 09:34:39PM +0200, Maxim Levitsky wrote:
> > But this just adds the WQ_UNBOUND. Dunno, without lock I had several
> > crashes, that for high level of confidence caused by by parallel
> > execution of work items. Once I added this mutex, I couldnt reproduce
> > these.
> 
> Yes the combination of WQ_UNBOUND and max_active==1 guarantees
> strictly ordered one-by-one execution.
> 
> > I had the __blk_end_request fail with NULL msb->req. I can't see how
> > that can happen if work queue isn't executed in parallel.
> > (and then the I didn't even had by mistake the code that sets it to NULL
> > in msb_stop, so I really fail to see how that could happen due internal
> > bug in my code. 
> 
> If you're seeing parallel execution w/ ordered workqueue, it is a
> critical bug which would make the kernel crash left and right.  Please
> try alloc_ordered_workqueue() and if you still see parallel execution,
> please report.
I will test this very soon. Good to know, I am pretty sure, it will
work.

> 
> Thanks.
> 

-- 
Best regards,
        Maxim Levitsky

