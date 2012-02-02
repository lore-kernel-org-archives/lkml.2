Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2BBTaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:30:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038Ab2BBTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:30:04 -0500
Date: Thu, 2 Feb 2012 14:29:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: unify blkgs for different policies
Message-ID: <20120202192958.GA1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:19:05PM -0800, Tejun Heo wrote:

[..]
> 
> * use unified stats updated under queue lock and drop percpu stats
>   which should fix locking / context bug across percpu allocation.

Hi Tejun,

Does that mean that stat updation will happen under queue lock even if
there are no throttling rules? That will introduce extra queue lock on
fast path those who have throttling compiled in but are not using (common
case for distributions).

IMHO, we should keep the lockless per cpu stats and do the allocation in
worker thread. I was going through my messages and noticed that for
a workload queue lock contention had come down by 11% and in a separate
testing I could gain 4-5% with PCIe based flash drive for random reads
while I saturated the cpus.

Thanks
Vivek
