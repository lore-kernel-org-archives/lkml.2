Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0G1VdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:33:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab0G1Vc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:32:59 -0400
Subject: Re: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak (v2)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1280220298-9641-1-git-send-email-chris@chris-wilson.co.uk>
References: <1280177744.27682.2.camel@e102109-lin.cambridge.arm.com>
	 <1280220298-9641-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 28 Jul 2010 22:32:42 +0100
Message-ID: <1280352762.18075.3.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2010 21:32:42.0848 (UTC) FILETIME=[69695E00:01CB2E9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 09:44 +0100, Chris Wilson wrote:
> kmemleak ignores page_alloc() and so believes the final sub-page
> allocation using the plain kmalloc is decoupled and lost. This leads to
> lots of false-positives with code that uses scatterlists.
> 
> The options seem to be either to tell kmemleak that the kmalloc is not
> leaked or to notify kmemleak of the page allocations. The danger of the
> first approach is that we may hide a real leak, so choose the latter
> approach (of which I am not sure of the downsides).
> 
> v2: Added comments on the suggestion of Catalin.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks. The patch looks good. I'll place it in my kmemleak branch and
send it to Linus together with other kmemleak patches (hopefully I won't
miss the merging window as I'm going on holiday for a week).

-- 
Catalin

