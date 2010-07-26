Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0GZU4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:56:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab0GZU4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:56:03 -0400
Subject: Re: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1280067675-7610-1-git-send-email-chris@chris-wilson.co.uk>
References: <1280067675-7610-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 26 Jul 2010 21:55:44 +0100
Message-ID: <1280177744.27682.2.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2010 20:55:45.0457 (UTC) FILETIME=[EAEADA10:01CB2D04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-25 at 15:21 +0100, Chris Wilson wrote:
> kmemleak ignores page_alloc() and so believes the final sub-page
> allocation using the plain kmalloc is decoupled and lost. This leads to
> lots of false-positives with code that uses scatterlists.
> 
> The options seem to be either to tell kmemleak that the kmalloc is not
> leaked or to notify kmemleak of the page allocations. The danger of the
> first approach is that we may hide a real leak, so choose the latter
> approach (of which I am not sure of the downsides).

The patch looks fine to me. It would be useful to have some comment
where kmemleak_*() functions are called so that people reading the code
know why they are needed.

Thanks.

-- 
Catalin

