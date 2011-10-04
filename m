Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1JDJFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:05:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56158 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab1JDJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:05:01 -0400
Date: Tue, 4 Oct 2011 10:04:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20111004090446.GA10071@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <20110929192818.GB10425@mtj.dyndns.org>
 <20111003152126.GM18195@e102109-lin.cambridge.arm.com>
 <20111004075915.GE15637@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004075915.GE15637@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 08:59:15AM +0100, Tejun Heo wrote:
> On Mon, Oct 03, 2011 at 04:21:26PM +0100, Catalin Marinas wrote:
> > The updated patch below adds specific kmemleak API for percpu pointers
> > so that it only logs one call per allocation rather than the number of
> > possible cpus (could be split in two, though the patch is relatively
> > simple):
> 
> The percpu part looks fine to me but I don't know how kmemleak works
> to judge whether the kmemleak part is okay or not.  This just avoids
> false positives from slab and would still require bumping up the early
> log memory as # of cpus increases, right?

No, there is only one kmemleak call for each __percpu pointer (to the
specific kmemleak_*_percpu function). The kmemleak expands the percpu
pointer into corresponding blocks for each cpu but the early log only
stores a single call.

> For percpu part,
> 
>   Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

> How do you want to route this?  If kmemleak patches get routed through
> -mm, please feel free to send it to Andrew with Acked-by's added.

I'll push them to -next for now and (depending on how late the merge
window opens) I can send a pull request to Linus.

-- 
Catalin
