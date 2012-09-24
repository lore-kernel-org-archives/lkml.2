Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2IXSZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:25:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43890 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2IXSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:25:15 -0400
Date: Mon, 24 Sep 2012 11:25:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-ID: <20120924182511.GH7694@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
 <20120919145228.80f72f59.akpm@linux-foundation.org>
 <1348113942.16096.18.camel@maxim-laptop>
 <20120920175340.GE28934@google.com>
 <1348498747.618.4.camel@maxim-laptop>
 <1348499363.618.6.camel@maxim-laptop>
 <20120924180516.GF7694@google.com>
 <1348510768.618.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348510768.618.16.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 24, 2012 at 08:19:28PM +0200, Maxim Levitsky wrote:
> Except that if I schedule a same work item few times, these work items
> will be 'processed' in parallel, although there is just one work to do,
> work of pulling the requests from block queue until it has them, and
> dispatching them through my code.
> Or I can get a guarantee that work items wont be processed in parallel?

You need to use system_nrt_wq for that before 3.7-rc1.  After 3.7-rc1,
any workqueue will guarantee that.

> Stiil, even with that only first work item will do the actual work,
> others will wake the workqueue for nothing, but I am ok with that.

It's just like waking up spuriously.  The work item is guaranteed to
be executed at least once after any given schedule/queue_work() call.

Thanks.

-- 
tejun
