Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2IYSCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:02:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2IYSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:02:39 -0400
Date: Tue, 25 Sep 2012 11:02:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 memstick: support for legacy sony memsticks
Message-ID: <20120925180235.GC16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> * Swithced to using a workqueue.
>   Unfortunelly, I still see that workqueue items are executed in parallel
>   I suspect that this happens if one work item sleeps. In this case I
>   don't want other work items to run too. I fixed this with a mutex, and anyway
>   it nice to have it to guaranteee this.

You can use alloc_ordered_workqueue("namefmt", WQ_MEM_RECLAIM).  No
mutex needed for inter-work exclusion.

Thanks.

-- 
tejun
