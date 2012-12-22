Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2LVCPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:15:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2LVCPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:15:37 -0500
Date: Fri, 21 Dec 2012 18:15:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-Id: <20121221181523.0e0998e4.akpm@linux-foundation.org>
In-Reply-To: <1356141435-17340-26-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	<1356141435-17340-26-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012 17:57:15 -0800 Tejun Heo <tj@kernel.org> wrote:

> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.

> -		if (!work_pending(&ipc_memory_wq))
> -			schedule_work(&ipc_memory_wq);
> +		schedule_work(&ipc_memory_wq);

Well, the new code is a ton slower than the old code if the work is
frequently pending, so some care is needed with such a conversion.

That's not an issue for the IPC callsite - memory offlining isn't
frequent.

> ...
>
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 

Please merge this one yourself.

