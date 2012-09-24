Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2IXO7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:59:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54453 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2IXO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:59:12 -0400
Message-ID: <1348498747.618.4.camel@maxim-laptop>
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Sep 2012 16:59:07 +0200
In-Reply-To: <20120920175340.GE28934@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
	 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
	 <20120919145228.80f72f59.akpm@linux-foundation.org>
	 <1348113942.16096.18.camel@maxim-laptop>
	 <20120920175340.GE28934@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 10:53 -0700, Tejun Heo wrote: 
> On Thu, Sep 20, 2012 at 07:05:42AM +0300, Maxim Levitsky wrote:
> > There can't be races in the driver, since it contains a single thread
> > that does all the IO it got from block layer.
> > The thread is awaken each time the request function of block device is
> > called.
> > This why I didn't do much locking in here. In addition I found out that
> > this is quite common way to implement a block device driver.
> 
> Please use workqueue instead of raw kthread.
> 
> Thanks!
Now that my exams done....
Can you spare me from using a workqueue?
The point is that using current model I wake the worker thread as much
as I want to, and I know that it will be woken once an will do all the
work till request queue is empty.
With workqueues, it doesn't work this way. I have to pass the request as
a work item or something like that.
Any pointers?

Best regards,
Maxim Levitsky 

