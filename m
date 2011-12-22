Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1LVWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:09:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54889 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1LVWJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:09:17 -0500
Date: Thu, 22 Dec 2011 14:09:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111222220911.GK17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222135925.de3221c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 01:59:25PM -0800, Andrew Morton wrote:
> How about we just delete those statistics and then this patchset?
> 
> Or how about we change those statistics to not do percpu allocations,
> then delete this patchset?

I'm not against above both but apparently those percpu stats reduced
CPU overhead significantly.

> Or how about we fix the percpu memory allocation code so that it
> propagates the gfp flags, then delete this patchset?

Oh, no, this is gonna make things *way* more complex.  I tried.  If
we're gonna have many more NOIO percpu users, which I don't think we
would or should, that might make sense but, for fringe cases,
extending mempool to cover percpu is a much better sized solution.

Thanks.

-- 
tejun
